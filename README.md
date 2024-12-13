# Project Setup Instructions

Follow these steps to set up and run the project locally on your system:

## Prerequisites

- Ensure you have [Flutter](https://flutter.dev/docs/get-started/install) installed on your system.
- Ensure you have a compatible code editor such as [Visual Studio Code](https://code.visualstudio.com/).
- Make sure you have a modern web browser (e.g., Chrome) installed for running the project on the web.

## Steps to Set Up and Run the Project

1. *Open Target Folder on VS Code*
   - Navigate to the directory where you want to clone the repository.
   - Open this directory in Visual Studio Code.

2. *Clone the Repository*
   bash
   git clone <url-repo>
   
   Replace <url-repo> with the URL of the repository you want to clone.

3. *Navigate to the Project Folder*
   - Use the cd command followed by pressing Tab to auto-complete the folder name:
     bash
     cd <press tab>
     
   - Press Enter to navigate into the project directory.

4. *Run the Project*
   - Use the following command to run the Flutter project in Chrome:
     bash
     flutter run -d chrome
     

## Additional Notes

- Ensure you have all the necessary dependencies installed for Flutter. Run the following command if needed:
  bash
  flutter pub get
  
- If you encounter issues, try checking the Flutter environment setup using:
  bash
  flutter doctor
