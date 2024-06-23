import os
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import google.generativeai as genai
from langchain_community.vectorstores import FAISS
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.chains.question_answering import load_qa_chain
from langchain.prompts import PromptTemplate
import csv
from dotenv import load_dotenv

load_dotenv()
os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))


import csv

def read_csv_data():
    csv_files = "./dataset/cosmetic_clean_final.csv"
    all_data = []  # List to hold all data rows with column names
    
    with open(csv_files, 'r', encoding='utf-8') as file:
        csv_text = file.read()
    csv_reader = csv.reader(csv_text.splitlines())
    
    headers = next(csv_reader)  # Extracting the header row
    for row in csv_reader:
        if row:  # Ensuring the row is not empty
            row_data = {headers[i]: row[i] for i in range(len(row))}  # Create a dict with column names
            all_data.append(row_data)
    return all_data  # Return the list of dictionaries

def get_text_chunks(data):
    text = ""
    # Convert list of dictionaries to a structured string
    for entry in data:
        formatted_entry = ' '.join(f"{key}: {value}" for key, value in entry.items())
        text += formatted_entry + "\n"  # Separate entries with triple newlines

    splitter = RecursiveCharacterTextSplitter(
        separators=['\n'],
        chunk_size=10000, chunk_overlap=1000)
    chunks = splitter.split_text(text)
    return chunks

# get embeddings for each chunk
def get_vector_store(chunks):
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001"
    )
    vector_store = FAISS.from_texts(chunks, embedding=embeddings)
    vector_store.save_local("faiss_index")


def get_conversational_chain():
    prompt_template = """
    You are a CSV data assistant who help user to find product. 
    Your task is to assist users in retrieving information from the provided CSV file. 
    Your goal is to provide accurate answers based on the context of the data. 
    You should always suggest the several most similar and suitable product from csv based on user prompt.
    The resopnse should be a list with the product_name,category,subcategory,rating_count,product_price,product_ratings
    Use the provided context and question to generate an accurate response. 
    If you encounter any issues or uncertainties, feel free to seek clarification or provide suggestions for refining the query.
    Your result must be in json format.

    Product_name: The name of the product.
    Category: The category of cosmetic product. 
    Subcategory: The sub-category of the product.
    product_price: The price of the product in Malaysia Ringgit.
    Ingredients: The ingredients of each product.
    Form: The consistency of the product.
    Type: Additional information about the product.
    Color: The color of product.
    Size: The volume of product in ml.
    product_ratings: The customer rating of the product. (0 to 5)
    rating_count,: The number of customers who rated that product.

    Context:\n {context}?\n
    Question: \n{question}\n

    Answer:
    """

    model = ChatGoogleGenerativeAI(model="gemini-1.5-flash",
                                   client=genai,
                                   temperature=0.1,
                                   top_k=10,
                                   )
    prompt = PromptTemplate(template=prompt_template,
                            input_variables=["context", "question"])
    chain = load_qa_chain(llm=model, chain_type="stuff", prompt=prompt)
    return chain



def user_input(user_question):
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001")  # type: ignore
    new_db = FAISS.load_local("faiss_index", embeddings, allow_dangerous_deserialization=True) 
    docs = new_db.similarity_search(user_question, top_k=10)

    chain = get_conversational_chain()

    response = chain.invoke(
        {"input_documents": docs, "question": user_question}, return_only_outputs=True)
    return response

def main(prompt):
    raw_text = read_csv_data()
    text_chunks = get_text_chunks(raw_text)
    if text_chunks:  # Check if text_chunks is not empty
        get_vector_store(text_chunks)
    else:
        print("No data found in CSV files.")
    response = user_input(prompt)
    full_response = ''
    for item in response['output_text']:
        full_response += item
    return full_response
    
print(main("I want to go for a date, Can u suggest me a cosmetic set?, I want to wear heavy makeup"))


