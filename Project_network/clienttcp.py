from socket import *
import time


clientsock = socket(AF_INET, SOCK_STREAM)

# Connect the socket to the server
server_address = ("localhost", 5566)
print('connecting to {} port {}'.format(*server_address))
clientsock.connect(server_address)
start_time = time.time()


# Send the numbers from 0 to 1,000,000
for i in range(1000000):
    clientsock.sendall(str(i).encode())
end_time = time.time()

# calculate the total time
total_time = end_time - start_time
print('total time required to send packets: {} seconds'.format(total_time))
# Close the socket
clientsock.close()
