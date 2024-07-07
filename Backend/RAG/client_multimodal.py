import requests

# Define the URL of the FastAPI endpoint
url = "http://localhost:8000/query"

# Specify the path to the image file you want to upload
image_path = "sample.jpg"

# Specify the text prompt
text_prompt = "Suggest me a face wash and serum for my face"

# Open the image file in binary mode
with open(image_path, "rb") as image_file:
    # Create a dictionary to hold the file and the text prompt
    files = {"file": image_file}
    data = {"text": text_prompt}
    
    # Send a POST request to the FastAPI endpoint with the image and text prompt
    response = requests.post(url, files=files, data=data)
    
    # Check if the request was successful
    if response.status_code == 200:
        # Parse and print the JSON response
        result = response.json()
        print(result)
    else:
        # Print an error message if the request failed
        print(f"Request failed with status code {response.status_code}")
        print(response.text)
