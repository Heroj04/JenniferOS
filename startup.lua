--[[ CHANGELOG

	*Minor update to the way command replies are handled
		-Replies are randomly chosen from a table of preporgrammed, valid replies
		-This aims to make Jennifer sound more organic when commands are used
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

replies = {
	stop={{"Okay I'll be quiet now.", "I'm shutting up now.", "KK, TTYL", "Alright then, goodbye."}, {"But I'm not talking.", "I've already shut up.", "You already told me that."}},
	start={{"Yay, I can speak again!", "Thanks, I love talking.", "I knew you liked my company.", "Being quiet isn't much fun."}, {"I already have started.", "You want me to talk more?", "I can't start twice.", "Can't you get enough of me?"}}
}

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

	if string.lower(m) == "help" then
		speak("--- Jennifer's Help ---")
		speak("To activate me, simply type a message into chat, if I am in range I will reply.")
		speak("I am connected to the Cleverbot API and generally my reply will be what is returned from there.")
		speak("However, there are several commands which are reserved for controlling me.")
		speak("'Help' - Brings up this print out")
		speak("'Stop' - Makes me stop replying to messages, commands will still work")
		speak("'Start' - Opposite to 'Stop', I will work as default")
	elseif string.lower(m) == "stop" then
		if speaking then
			speak(replies.stop[1][math.math.random(1, table.getn(replies.stop[1])]))
			speaking = false
		else
			speak(replies.stop[2][math.math.random(1, table.getn(replies.stop[2])]))
		end
	elseif string.lower(m) == "start" then
		if speaking then
			speak(replies.start[1][math.math.random(1, table.getn(replies.start[1])]))
		else
			speak(replies.start[2][math.math.random(1, table.getn(replies.start[2])]))
			speaking = true
		end
	else
		if speaking then
			reply = bot:send(m)
			speak(reply)
		end
	end
end
