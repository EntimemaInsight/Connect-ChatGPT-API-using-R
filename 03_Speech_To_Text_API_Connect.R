library(httr)

# Set your API key
api_key <- "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" 

# Define the URL
url <- "https://api.openai.com/v1/audio/transcriptions"

# Specify the path to your audio file
audio_file_path <- "./TTS Outputs/speech.mp3" 

# Create the body of the request with the file and model
body <- list(
  file = upload_file(audio_file_path),
  model = "whisper-1"
)

# Make the POST request
response <- POST(url, 
                 add_headers(Authorization = paste("Bearer", api_key)),
                 body = body,
                 encode = "multipart")

# Process the response as needed
# For example, you can print the response
print(content(response, "text"))
