from huggingface_hub import login



import torch
from diffusers import StableDiffusion3Pipeline
from PIL import Image

pipe = StableDiffusion3Pipeline.from_pretrained("stabilityai/stable-diffusion-3-medium-diffusers", torch_dtype=torch.float16)
pipe = pipe.to("cuda")

image = pipe(
    "A cat holding a sign that says hello world",
    negative_prompt="",
    num_inference_steps=28,
    guidance_scale=7.0,
).images[0]
image


# Save the generated image
image.save("cat_hello_world.png")

