### Connect through R chatgpt library ### 

library(chatgpt)

Sys.setenv(OPENAI_API_KEY = "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")

cat(ask_chatgpt("Hi, this is a test. Please answer in up to 10 words."))

### Connect through httr ###

# Get your API key over here: https://platform.openai.com/
api_key <- "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" 
library(httr)
library(stringr)
# Calls the ChatGPT API with the given prompt and returns the answer
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

cat(ask_chatgpt("Hi, this is a test. Please answer in up to 10 words."))

response_string = ask_chatgpt("Hi, this is a test. Please answer in up to 10 words.")




















