# Set Global Parameters 
library(httr)
library(stringr)
library(jsonlite)

api_key <- "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" 

# Create conversation starting line
Conversation_Opening_Line = "What do you think about AI?"

# Define the API endpoint for text to speech
url <- "https://api.openai.com/v1/audio/speech"

# Create the body of the request
body <- list(
  model = "tts-1",
  input = Conversation_Opening_Line,
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

### Transcribe the created speech input file ### 

audio_file_path <- "./TTS Outputs/speech_input.mp3" 

# Define the API endpoint for transcribing the speech file to text
url <- "https://api.openai.com/v1/audio/transcriptions"

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
parsed_response <- fromJSON(content(response, "text", encoding = "UTF-8"))
raw_text_response <- parsed_response$text

### Send it to GPT-3.5 ###

# Define text string to be sent to gpt (limited to 3 sentences)
text_for_gpt = paste0(raw_text_response,". Respond in up to 3 sentences,please.")

# define function to communicate with GPT model API endpoint
ask_chatgpt <- function(prompt) {
  response <- POST(
    url = "https://api.openai.com/v1/chat/completions", 
    add_headers(Authorization = paste("Bearer", api_key)),
    content_type_json(),
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",
      messages = list(list(
        role = "user", 
        content = prompt
      ))
    )
  )
  #str_trim(content(response)$choices[[1]]$message$content)
  response_text <- str_trim(content(response)$choices[[1]]$message$content)
  return(response_text)
}

gpt_response = ask_chatgpt(text_for_gpt)

### Convert the text response from GPT back to speech ###
# Define the API endpoint for text to speech
url <- "https://api.openai.com/v1/audio/speech"

# Create the body of the request
body <- list(
  model = "tts-1",
  input = gpt_response,
  voice = "alloy"
)

# Make the POST request
response <- POST(url, 
                 add_headers(Authorization = paste("Bearer", api_key), 
                             `Content-Type` = "application/json"),
                 body = body, 
                 encode = "json")

# Save the output
writeBin(content(response, "raw"), "./TTS Outputs/speech_output.mp3")


