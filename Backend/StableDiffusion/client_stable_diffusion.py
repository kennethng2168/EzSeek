import requests
from PIL import Image
from io import BytesIO

def generate_image(prompt):
    url = "http://localhost:8000/generate-image/"
    response = requests.post(url, params={"prompt": prompt})
    
    if response.status_code == 200:
        image = Image.open(BytesIO(response.content))
        image.show()
        image.save("test.png")
    else:
        print(f"Failed to generate image: {response.status_code} - {response.text}")

if __name__ == "__main__":
    prompt = "Create a visually striking scene depicting the destructive impact of a landslide on a serene landscape. Rendered in detailed 16K resolution, show the aftermath with debris-strewn slopes, uprooted trees, and displaced wildlife. Emphasize the sudden and powerful force of nature, highlighting the need for disaster preparedness and environmental awareness."
    generate_image(prompt)
