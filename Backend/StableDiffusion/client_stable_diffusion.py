import requests
from PIL import Image
from io import BytesIO

def generate_image(prompt):
    url = "http://localhost:8000/generate-image/"
    response = requests.post(url, params={"prompt": prompt})
    
    if response.status_code == 200:
        image = Image.open(BytesIO(response.content))
        image.show()
    else:
        print(f"Failed to generate image: {response.status_code} - {response.text}")

if __name__ == "__main__":
    prompt = "A beautiful landscape with mountains and rivers"
    generate_image(prompt)
