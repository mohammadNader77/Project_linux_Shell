from socket import *

serverPort = 7788
serverSocket = socket(AF_INET, SOCK_STREAM)
serverSocket.bind(("", serverPort))
# Listen for incoming connections
serverSocket.listen(1)

print("The server is ready to receive")


while True:
    connectionSocket, addr = serverSocket.accept()
    sentence = connectionSocket.recv(1024).decode()
    print("IP: " + addr[0] + ", Port: " + str(addr[1]))
    print(sentence)
    ip = addr[0]
    port = addr[1]
    string_list = sentence.split(' ')  # Split request from spaces
    method = string_list[0]
    requestFile = string_list[1]
    connectionSocket.send(f"HTTP/1.1 200 OK\r\n".encode())
    # After the "?" symbol not relevent here
    myfile = requestFile.split('?')[0]
    myfile = myfile.lstrip('/')

    if myfile == "go":
        connectionSocket.send(
            f"HTTP/1.1 307 Temporary Redirect\r\nLocation: https://www.google.com\r\n".encode())
    elif myfile == "so":
        connectionSocket.send(
            f"HTTP/1.1 307 Temporary Redirect\r\nLocation: https://stackoverflow.com\r\n".encode())
    elif myfile == "bzu":
        connectionSocket.send(
            f"HTTP/1.1 307 Temporary Redirect\r\nLocation: https://birzeit.edu\r\n".encode())
    else:
        try:

            if myfile == '' or myfile == 'index.html' or myfile == 'en':
                myfile = 'main_en.html'  # Default File

            requestFile = open(myfile, 'rb')
            response = requestFile.read()
            requestFile.close()

            if myfile.endswith(".jpg"):
                connectionSocket.send(f"Content-Type: image/jpg \r\n".encode())
            elif myfile.endswith(".png"):
                connectionSocket.send(f"Content-Type: image/png \r\n".encode())

            elif myfile.endswith(".css"):
                connectionSocket.send(f"Content-Type: text/css \r\n".encode())

            else:
                connectionSocket.send(f"Content-Type: text/html \r\n".encode())

        except Exception as e:
            header = 'HTTP/1.1 404 Not Found\n\n'
            response = ('<html><title>Error</title><body><center><h1>Error 404:<p style= "color: red;"</p> The File Is Not Found</h1> </h1><hr><p style= "font-weight: bold;">Mohammad shrateh - 1201369</p><p style="font-weight: bold;"</p><hr><h2>IP: ' + str(
                ip) + ', Port: ' + str(port) + '</h2></center></body></html>').encode('utf-8')

        connectionSocket.send(f"\r\n".encode())
        connectionSocket.send(response)
        # close the socket
        connectionSocket.close()
