from socket import *
import time
# Create a client socket
client_socket = socket(AF_INET, SOCK_STREAM)
client_address = ('localhost', 5566)

# Connect to the server's IP address and port number
client_socket.connect(client_address)
print('starting up on {} port {}'.format(*client_address))

start_time = time.time()
# Send the numbers from 0 to 1000,000 to the server
for i in range(1000000):
    client_socket.send(str(i).encode())

end_time = time.time()

# calculate the total time
total_time = end_time - start_time
print('total time required to send packets: {} seconds'.format(total_time))
# Close the client socket
client_socket.close()
