#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include <cctype>
#include <regex>

using namespace std;

struct RGB {
	int r, g, b;

	RGB(int r = 0, int g = 0, int b = 0) : r(r), g(g), b(b) {}

	string toHex() const {
		stringstream ss;
		ss << "#" << hex << uppercase 
			<< setw(2) << setfill('0') << r
			<< setw(2) << setfill('0') << g
			<< setw(2) << setfill('0') << b;
		return ss.str();
	}
};

RGB hexToRgb(const string& hexColor) {
	string cleanHex = hexColor;

	// Remove # if present
	if (!cleanHex.empty() && cleanHex[0] == '#') {
		cleanHex = cleanHex.substr(1);
	}

	// Handle 3-digit hex (e.g., #abc -> #aabbcc)
	if (cleanHex.length() == 3) {
		cleanHex = string() + cleanHex[0] + cleanHex[0] + 
			cleanHex[1] + cleanHex[1] + 
			cleanHex[2] + cleanHex[2];
	}

	if (cleanHex.length() != 6) {
		throw invalid_argument("Invalid hex colour format");
	}

	int r, g, b;
	stringstream ss;

	// Convert hex to integers
	ss << hex << cleanHex.substr(0, 2);
	ss >> r;
	ss.clear();

	ss << hex << cleanHex.substr(2, 2);
	ss >> g;
	ss.clear();

	ss << hex << cleanHex.substr(4, 2);
	ss >> b;

	return RGB(r, g, b);
}

// ANSI escape codes for colours
const string RESET = "\033[0m";

string colourBg(const RGB& rgb) {
	return "\033[48;2;" + to_string(rgb.r) + ";" + 
		to_string(rgb.g) + ";" + 
		to_string(rgb.b) + "m";
}

const string WHITE_BG = "\033[48;2;255;255;255m";
const string BLACK_BG = "\033[48;2;0;0;0m";
const string WHITE_TEXT = "\033[38;2;255;255;255m";
const string BLACK_TEXT = "\033[38;2;0;0;0m";

void displayColorBlock(const RGB& rgb, int width = 30, int height = 5) {
	string colour_bg = colourBg(rgb);

	cout << "\n" << string(50, '=') << endl;
	cout << "Displaying colour: RGB(" << rgb.r << ", " << rgb.g << ", " << rgb.b << ")" << endl;
	cout << string(50, '=') << "\n" << endl;

	// Display on white background
	// Top border
	cout << WHITE_BG << BLACK_TEXT << string(50, ' ') << RESET << endl;

	for (int i = 0; i < height; i++) {
		cout << WHITE_BG << BLACK_TEXT << string(10, ' ') << RESET
			<< colour_bg << string(width, ' ') << RESET
			<< WHITE_BG << BLACK_TEXT << string(10, ' ') << RESET << endl;
	}

	// Bottom border
	cout << WHITE_BG << BLACK_TEXT << string(50, ' ') << RESET << endl;

	cout << "\n" << string(50, '-') << "\n" << endl;

	// Display on black background
	// Top border
	cout << BLACK_BG << WHITE_TEXT << string(50, ' ') << RESET << endl;

	for (int i = 0; i < height; i++) {
		cout << BLACK_BG << WHITE_TEXT << string(10, ' ') << RESET
			<< colour_bg << string(width, ' ') << RESET
			<< BLACK_BG << WHITE_TEXT << string(10, ' ') << RESET << endl;
	}

	// Bottom border
	cout << BLACK_BG << WHITE_TEXT << string(50, ' ') << RESET << endl;

	cout << "\n" << string(50, '=') << endl;
	cout << "Hex: " << rgb.toHex() << endl;
	cout << string(50, '=') << endl;
}

bool isValidHexColor(const string& colour) {
	// Regex for #RRGGBB or RRGGBB or #RGB or RGB
	regex hexPattern("^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$");
	return regex_match(colour, hexPattern);
}

void printHelp() {
	cout << "\nColor Block Display - Help" << endl;
	cout << "=========================" << endl;
	cout << "Enter colours in these formats:" << endl;
	cout << "  - #RRGGBB (e.g., #e06c75)" << endl;
	cout << "  - RRGGBB (e.g., e06c75)" << endl;
	cout << "  - #RGB (e.g., #abc expands to #aabbcc)" << endl;
	cout << "  - RGB (e.g., abc expands to aabbcc)" << endl;
	cout << "\nCommands:" << endl;
	cout << "  - 'exit' or 'quit': Exit the program" << endl;
	cout << "  - 'help': Show this help message" << endl;
	cout << "=========================\n" << endl;
}

int main() {
	cout << "=================================" << endl;
	printHelp();

	string input;

	while (true) {
		cout << "\nEnter colour (or 'help'/'exit'): ";
		getline(cin, input);

		// Convert to lowercase for command checking
		string lowerInput = input;
		transform(lowerInput.begin(), lowerInput.end(), lowerInput.begin(), ::tolower);

		if (lowerInput == "exit" || lowerInput == "quit") {
			break;
		}

		if (lowerInput == "help") {
			printHelp();
			continue;
		}

		if (input.empty()) {
			continue;
		}

		try {
			if (!isValidHexColor(input)) {
				cout << "Error: Invalid hex colour format. Type 'help' for valid formats." << endl;
				continue;
			}

			RGB rgb = hexToRgb(input);
			displayColorBlock(rgb);

		} catch (const invalid_argument& e) {
			cout << "Error: " << e.what() << endl;
		} catch (const exception& e) {
			cout << "Unexpected error: " << e.what() << endl;
		}
	}

	return 0;
}
