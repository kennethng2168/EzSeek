import io
import os
import csv
import json
from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings, ChatGoogleGenerativeAI
import google.generativeai as genai
from langchain_community.vectorstores import FAISS
from langchain.chains.question_answering import load_qa_chain
from langchain.prompts import PromptTemplate
from langchain_core.messages import HumanMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from dotenv import load_dotenv
from PIL import Image
from guardrails import Guard
from guardrails.hub import(
    CompetitorCheck,
    GibberishText,
    RestrictToTopic,
    WikiProvenance,
    ToxicLanguage
)

# Load environment variables
load_dotenv()
genai_api_key = os.getenv("GOOGLE_API_KEY")
if not genai_api_key:
    raise ValueError("GOOGLE_API_KEY environment variable not set.")
genai.configure(api_key=genai_api_key)

# Initialize Guardrails
guard = Guard().use_many(
    CompetitorCheck(
        competitors=["instagram", "facebook", "reddit"]  # Replace with actual competitors
    ),
    GibberishText(),
   
    ToxicLanguage(
        validation_method="sentence",  # Ensure this matches your implementation
        threshold=0.5
    )
)

# FastAPI app setup
app = FastAPI()

# Define models for API requests and responses
class QueryRequest(BaseModel):
    query: str

# Utility functions
def read_csv_data():
    csv_files = "./dataset/cosmetic_clean_final.csv"
    all_data = []
    
    with open(csv_files, 'r', encoding='utf-8') as file:
        csv_reader = csv.reader(file)
        headers = next(csv_reader)
        for row in csv_reader:
            if row:
                row_data = {headers[i]: row[i] for i in range(len(row))}
                all_data.append(row_data)
    return all_data

def get_text_chunks(data):
    text = ""
    for entry in data:
        formatted_entry = ' '.join(f"{key}: {value}" for key, value in entry.items())
        text += formatted_entry + "\n"
    
    splitter = RecursiveCharacterTextSplitter(separators=['\n'], chunk_size=10000, chunk_overlap=1000)
    chunks = splitter.split_text(text)
    return chunks

def get_vector_store(chunks):
    embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
    vector_store = FAISS.from_texts(chunks, embedding=embeddings)
    vector_store.save_local("faiss_index")
    return vector_store

raw_text = read_csv_data()
text_chunks = get_text_chunks(raw_text)
vector_store = get_vector_store(text_chunks) if text_chunks else None

if not vector_store:
    raise ValueError("No data found in CSV files or failed to create vector store.")

retriever = vector_store.as_retriever()

template = """
    You are a CSV data assistant who helps users find products. 
    Your task is to retrieve information from the provided CSV file. 
    Your goal is to provide accurate answers based on the context of the data. 
    You should always suggest the most similar and suitable products from the CSV based on the user prompt.
    The response should be a list with the product_name, category, subcategory, rating_count, product_price, and product_ratings.
    You can suggest more than one product.
    Use the provided context and question to generate an accurate response. 
    Your result must be in JSON format without ```json```.

    Product_name: The name of the product.
    Category: The category of the cosmetic product. 
    Subcategory: The sub-category of the product.
    Product_price: The price of the product in Malaysian Ringgit.
    Ingredients: The ingredients of each product.
    Form: The consistency of the product.
    Type: Additional information about the product.
    Color: The color of the product.
    Size: The volume of the product in ml.
    Product_ratings: The customer rating of the product. (0 to 5)
    Rating_count: The number of customers who rated that product.

    ```
    {context}
    ```

    {information}
"""
prompt = ChatPromptTemplate.from_template(template)

rag_chain = (
    {"context": retriever, "information": RunnablePassthrough()}
    | prompt
    | ChatGoogleGenerativeAI(model="gemini-1.5-flash")
    | StrOutputParser()
)

llm_vision = ChatGoogleGenerativeAI(model="gemini-1.5-flash", temperature=0.0)
full_chain = (
    RunnablePassthrough() | llm_vision | StrOutputParser() | rag_chain
)

# FastAPI endpoints
@app.post("/query")
async def query_data(file: UploadFile = File(...), text: str = Form(...)):
    try:
        # Apply guardrails to validate input text
        guard.validate(text)
        
        image_data = await file.read()
        image = Image.open(io.BytesIO(image_data))
        
        # Process the image and text prompt
        message = HumanMessage(
            content=[
                {"type": "text", "text": text},
                {"type": "image_url", "image_url": file.filename},
            ]
        )
        
        result = full_chain.invoke([message])
        
         # Apply guardrails to validate output
        guard.validate(result)
        print(result)
        products = json.loads(result)
        return products
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Run the FastAPI application
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
