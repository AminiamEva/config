#include <iostream>
#include <chrono>
#include <thread>
#include <ctime>

using namespace std;

int main()
{
    while (true)
    {
        cout << "\033[H";
        auto now = chrono::system_clock::now();
        time_t now_time = std::chrono::system_clock::to_time_t(now);
        tm* local_time = std::localtime(&now_time);
        char buffer[80];
        strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local_time);
	cout << "+=====================+" << endl;
	std::cout << "\033[J";
	cout << "# ";
        cout << buffer << std::flush;
	cout << " #" << endl;
	std::cout << "\033[J";
	cout << "+=====================+";
        cout << "\033[J";
        this_thread::sleep_for(std::chrono::seconds(1));
    }
    return 0;
}
