from socket import *
import time
# Create a server socket
server_socket = socket(AF_INET, SOCK_STREAM)
server_address = ('localhost', 5566)

# Bind the socket to the given port and IP address
server_socket.bind(server_address)
print('starting up on {} port {}'.format(*server_address))
# Start listening for incoming connections
server_socket.listen()

# Accept incoming connections
client_socket, addr = server_socket.accept()

start_time = time.time()
count = 0

while True:
    # Receive data from the client
    data = client_socket.recv(1024)
    if not data:
        # Stop receiving if the client has closed the connection
        break
    count += 1

# Print the number of received messages
print(f'Received {count} messages.')
end_time = time.time()
# calculate the total time
total_time = end_time - start_time
print('total time required to receive packets: {} seconds'.format(total_time))
# Close the client and server sockets
client_socket.close()
server_socket.close()
