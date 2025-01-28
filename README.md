🎮 Jeopardy Game System 🎉

🚀 Overview

This project implements a Jeopardy game system in Assembly Language, designed to create an exciting and competitive quiz environment with real-time buzzer functionality. The system ensures fairness and clear indication of the first player to respond during gameplay. 🕹️✨
🌟 Features

👥 Three-player Buzzer System: Supports three participants in the game.
🔒 Exclusive Response Logic: Once a player presses their buzzer, their respective light is activated, and subsequent inputs from others are ignored.
💡 Visual Feedback: Instantly lights up the corresponding LED for the first player to press their buzzer.
🤝 Fair Competition: Ensures only the first input is registered, promoting a level playing field.
⚡ Efficient and Reliable: Written in Assembly Language for maximum performance on resource-constrained embedded systems.
🛠️ Technical Details

🔤 Programming Language: Assembly Language
🖥️ Hardware Requirements:
📟 Microcontroller (e.g., RISC-V, AVR, or 8051-based boards)
🔘 Three push-button switches for the buzzer
💡 Three LEDs for visual feedback
🔌 Power supply and resistors for LED connections (if required)
⚙️ Logic Implementation:
1️⃣ Polling or interrupt-driven input handling for buzzers.
2️⃣ Lock-out mechanism to ignore subsequent inputs after the first response.
3️⃣ Reset functionality to prepare the system for the next question.
🎯 How It Works

🕹️ At the start of each round, the system resets and awaits input from any of the three players.
🎇 The first player to hit their buzzer triggers the corresponding LED, indicating their response.
🛑 Additional inputs from other players are ignored until the round resets.
🔄 The system is manually or automatically reset for the next question.
🎲 Use Case

This system is ideal for:
🏫 Classroom quizzes
🎥 Game shows
🏋️‍♂️ Training sessions requiring a quick-response mechanism
🎁 Advantages

⚡ Speed and Accuracy: Captures only the first input to avoid disputes.
🗜️ Compact Codebase: Efficient Assembly Language implementation ensures fast and reliable performance.
🔧 Scalability: Expandable to support more players or integrate with larger game systems.
🔮 Future Enhancements

⏱️ Add a timer to track players' response times.
🧮 Incorporate a scorekeeping system.
🧑‍🤝‍🧑 Support more than three players by expanding the hardware.
🖥️ Develop a digital display to show the player ID who buzzed first.
