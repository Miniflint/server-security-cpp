import os
import sys
import socket
import threading
from datetime import datetime

HOST = "127.0.0.1"
PORT = 8000
ENCODING = "utf-8"
clients = []
client_lock = threading.Lock()

def handle_write_in_file_for_dad(str_to_write:str, connection:socket.socket, dad_mom:int) -> None:
    security_folder = "./security"
    new_data:str = connection.recv(1024).decode(ENCODING)
    print(new_data)
    now = datetime.now()
    if not os.path.isdir(security_folder):
        os.mkdir(security_folder)
    if dad_mom == 1:
        file_name = security_folder + "/dad_user_opened.txt"
    else:
        file_name = security_folder + "/mom_user_opened.txt"
    if (not new_data):
        print("Empty data")
        return
    if (os.path.isfile(file_name)):
        f = open(file_name, "a")
    else:
        f = open(file_name, "w")
    date_time_now = now.strftime("[%d.%m.%Y %H:%M:%S] ")
    f.write(date_time_now + new_data + "\n")
    connection.close()

def threaded(c) -> None:
    id_thread = threading.get_ident()
    now = datetime.now()
    dt_string = now.strftime("[%d.%m.%Y %H:%M:%S]")
    print(f"{dt_string} Thread nb: {id_thread} Started")
    while (True):
        try:
            data:bytes = c.recv(1024)
            if (str(data).find("VGhpcyBpcyBmb3IgZGFkIGNvbm5lY3Rpb24=") != -1):
                handle_write_in_file_for_dad(data, c, 1)
            elif (str(data).find("dGhpcyBpcyBmb3IgbW9tIGNvbm5lY3Rpb24=") != -1):
                handle_write_in_file_for_dad(data, c, 0)
            break
        except ConnectionResetError:
            break
    print(f"{dt_string} Thread nb: {id_thread} Disconnected")
    c.close()

def socket_loop() -> None:
    thread_list = []
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((HOST, PORT))
        s.listen()
        print(f"Socket is listening... on {HOST} - {PORT}")
        while (True):
            conn, addr = s.accept()
            with client_lock:
                clients.append(conn)
                t = threading.Thread(target=threaded, args=(conn,))
                t.daemon = True
                thread_list.append(t)
                t.start()
    for threads in thread_list:
        threads.join()

def main():
    try:
        socket_loop()
    except KeyboardInterrupt:
        sys.exit()

if __name__ == "__main__":
    main()