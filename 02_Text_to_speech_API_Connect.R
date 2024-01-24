### Text to speech

library(httr)

# Set your API key
api_key <- "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" 

# Define the URL
url <- "https://api.openai.com/v1/audio/speech"

# Create the body of the request
body <- list(
  model = "tts-1",
  input = "Arsenal are the best team in the world.",
  voice = "alloy"
)

# Make the POST request
response <- POST(url, 
                 add_headers(Authorization = paste("Bearer", api_key), 
                             `Content-Type` = "application/json"),
                 body = body, 
                 encode = "json")

# Save the output
writeBin(content(response, "raw"), "./TTS Outputs/speech_input.mp3")


