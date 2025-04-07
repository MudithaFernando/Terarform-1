variable "instance_count" {
  description = "Anzahl der zu erstellenden Webserver-Instanzen"
  type        = number
  default     = 1
  
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 3
    error_message = "Die Anzahl der Instanzen muss zwischen 1 und 3 liegen."
  }
}

variable "webserver_content" {
  description = "HTML-Inhalt für die Webserver-Startseite"
  type        = string
  default     = "<h1>Willkommen auf dem Webserver!</h1>"
}