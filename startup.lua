--[[ NOTE
	The first version of JenniferOS
	In this version she has the ability to reply to messages using the CleverBot API
	She also accepts basic Commands such as Stop and Start

	*There was a version before this which had no commands
]]--

term.clear()
term.setCursorPos(1,1)
os.loadAPI("clever")
chat = peripheral.wrap("right")
chat.setName("Jennifer")
chat.setDistance(256)
lastMsg = ""
speaking = true
bot = clever.cleverbot.new()

function speak(txt)
	if txt == lastMsg then
		print("DEBUG: REPEAT MESSAGE RECEIVED")
	else
		chat.say(txt)
		print(txt)
		lastMsg = txt
	end
end

speak("Hello, I am Jennifer. The Personal Companion Robot.")
speak("I can read and reply to messages spoken in chat. Remember I'm still not finished so I don't work perfectly.")
speak("If you don't know how I work, say 'Help' and I'll tell you what to do.")

while true do
	print("DEBUG: READY TO RECEIVE MESSAGES")

	local e, s, p, m = os.pullEvent("chat_message")

	if m == "Help" then
		speak("--- Jennifer's Help ---")
		speak("To activate me, simply type a message into chat, if I am in range I will reply.")
		speak("I am connected to the Cleverbot API and generally my reply will be what is returned from there.")
		speak("However, there are several commands which are reserved for controlling me.")
		speak("'Help' - Brings up this print out")
		speak("'Stop' - Makes me stop replying to messages, commands will still work")
		speak("'Start' - Opposite to 'Stop', I will work as default")
	elseif m == "Stop" then
		if speaking then
			speak("Okay, I'll be quiet now.")
			speaking = false
		else
			speak("I've already shut up.")
		end
	elseif m == "Start" then
		if speaking then
			speak("I've already started.")
		else
			speak("Yay, I can speak again.")
			speaking = true
		end
	else
		if speaking then
			reply = bot:send(m)
			speak(reply)
		end
	end
end
