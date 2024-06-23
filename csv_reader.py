import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import google.generativeai as genai
from langchain_community.vectorstores import FAISS
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.chains.question_answering import load_qa_chain
from langchain.prompts import PromptTemplate
import csv
from dotenv import load_dotenv
import json
from contextlib import asynccontextmanager

# Load environment variables
load_dotenv()
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# Model for request body
class QueryRequest(BaseModel):
    question: str

@asynccontextmanager
async def lifespan(app: FastAPI):
    global vector_store
    raw_text = read_csv_data()
    text_chunks = get_text_chunks(raw_text)
    if text_chunks:
        vector_store = get_vector_store(text_chunks)
        yield 
    else:
        raise HTTPException(status_code=500, detail="No data found in CSV files.")

app = FastAPI(lifespan=lifespan)


def read_csv_data():
    csv_file_path = "./dataset/cosmetic_clean_final.csv"
    all_data = []
    
    try:
        with open(csv_file_path, 'r', encoding='utf-8') as file:
            csv_reader = csv.reader(file)
            headers = next(csv_reader)
            for row in csv_reader:
                if row:
                    row_data = {headers[i]: row[i] for i in range(len(row))}
                    all_data.append(row_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error reading CSV file: {str(e)}")
    
    return all_data

def get_text_chunks(data):
    text = "\n".join([' '.join(f"{key}: {value}" for key, value in entry.items()) for entry in data])
    
    splitter = RecursiveCharacterTextSplitter(
        separators=['\n'],
        chunk_size=10000, chunk_overlap=1000
    )
    chunks = splitter.split_text(text)
    return chunks

def get_vector_store(chunks):
    embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
    vector_store = FAISS.from_texts(chunks, embedding=embeddings)
    vector_store.save_local("faiss_index")
    return vector_store

def get_conversational_chain():
    prompt_template = """
    You are a CSV data assistant who helps users to find products. 
    Your task is to assist users in retrieving information from the provided CSV file. 
    Your goal is to provide accurate answers based on the context of the data. 
    You should always suggest the several most similar and suitable products from the CSV based on user prompt.
    The response should be a list with the product_name, category, subcategory, rating_count, product_price, product_ratings.
    Use the provided context and question to generate an accurate response. 
    If you encounter any issues or uncertainties, feel free to seek clarification or provide suggestions for refining the query.
    Your result must be in JSON format without ```json```.

    Product_name: The name of the product.
    Category: The category of the cosmetic product. 
    Subcategory: The sub-category of the product.
    product_price: The price of the product in Malaysia Ringgit.
    Ingredients: The ingredients of each product.
    Form: The consistency of the product.
    Type: Additional information about the product.
    Color: The color of the product.
    Size: The volume of the product in ml.
    product_ratings: The customer rating of the product. (0 to 5)
    rating_count,: The number of customers who rated that product.

    Context:\n {context}?\n
    Question: \n{question}\n

    Answer:
    """

    model = ChatGoogleGenerativeAI(
        model="gemini-1.5-flash",
        client=genai,
        temperature=0.1,
        top_k=10,
    )
    prompt = PromptTemplate(
        template=prompt_template,
        input_variables=["context", "question"]
    )
    chain = load_qa_chain(llm=model, chain_type="stuff", prompt=prompt)
    return chain

def user_input(user_question, vector_store):
    embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
    new_db = FAISS.load_local("faiss_index", embeddings, allow_dangerous_deserialization=True)
    docs = new_db.similarity_search(user_question, top_k=10)
    
    chain = get_conversational_chain()
    response = chain.invoke({"input_documents": docs, "question": user_question}, return_only_outputs=True)
    return response

@app.post("/query")
async def query(request: QueryRequest):
    response = user_input(request.question, vector_store)
    json_data = response['output_text']
    products = json.loads(json_data)
    return products

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=3000)
