--[[ CHANGELOG
	VERSION - 1.4

	* Added new Debug command
	* Changed the way Debug messages are handled
	* slightly changed the way command functions are referenced

]]--

--Sets up the screen and loads the API
term.clear()
term.setCursorPos(1,1)
os.loadAPI("clever")

--Sets up enviroment variable used throughout the program
local peripheralSide = "right"
local chatName = "Jennifer"
local chatDist = 256
local chat = peripheral.wrap(peripheralSide)
local lastMsg = os.time()
local speaking = true
local bot = clever.Cleverbot.new()
local debug = false

--Setup chatbox
chat.setName(chatName)
chat.setDistance(chatDist)

--Speak function outputs text via chat and also prints on screen
function speak(txt, t, d)
	if t == lastMsg then
		if debug or not d then
			print("DEBUG: REPEAT MESSAGE DETECTED")
		end
	else
		if debug or not d then
			chat.say(txt)
		end
		print(txt)
		lastMsg = os.time()
	end
end

commands = {
	{
		name = "stop",
		successReply = {"Okay I'll be quiet now.", "I'm shutting up now.", "KK, TTYL", "Alright then, goodbye.", "Baiiiiiiii", "See ya later.", "cya", "C U L8R", "OK, but don't forget to start me again."},
		failReply = {"But I'm not talking.", "I've already shut up.", "You already told me that.", "You really don't like me?", "Sorry", "0_o ... I have."},
		help = "'Stop' - Makes me stop replying to messages, commands will still work."
	},
	{
		name = "help",
		successReply = {},
		failReply = {},
		help = "'Help' - Brings up this print out."
	},
	{
		name = "start",
		successReply = {"Yay, I can speak again!", "Thanks, I love talking.", "I knew you liked my company.", "Being quiet isn't much fun."},
		failReply = {"I already have started.", "You want me to talk more?", "I can't start twice.", "Can't you get enough of me?"},
		help = "'Start' - Opposite to 'Stop', will make me reply to messages again."
	},
	{
		name = "debug",
		successReply = {},
		failReply = {},
		help = "Debug - Toggles whether debug messages are spoken or just printed to console."
	}
}

function stopFunc(index, t)
	if speaking then
		speak(commands[index].successReply[math.random(#commands[index].successReply)], t)
		speaking = false
	else
		speak(commands[index].failReply[math.random(#commands[index].failReply)], t)
	end
end

function startFunc(index, t)
	if not speaking then
		speak(commands[index].successReply[math.random(#commands[index].successReply)], t)
		speaking = true
	else
		speak(commands[index].failReply[math.random(#commands[index].failReply)], t)
	end
end

function helpFunc(index, t)
	if t == lastMsg then
		speak("DEBUG: DUPLICATE MESSAGE", 0, true)
	else
		speak("--- Jennifer's Help ---")
		speak("To activate me, simply type a message into chat, if I am in range I will reply.")
		speak("I am connected to the Cleverbot API and generally my reply will be what is returned from there.")
		speak("However, there are several commands which are reserved for controlling me.")
		for j = 1, table.getn(commands) do
			speak(commands[j].help)
		end
	end
end

function debugTog()
	if debug then
		speak("DEBUG: DISABLED CHAT DEBUG MESSAGES", 0, true)
		debug = false
	else
		debug = true
		speak("DEBUG: ENABLED CHAT DEBUG MESSAGES", 0, true)
	end
end

commandFuncs = {
	--Must be in same order as commands object above
	stopFunc,
	helpFunc,
	startFunc,
	debugTog
}

speak("Hello, I am Jennifer. The Personal Companion Robot.")
speak("I can read and reply to messages spoken in chat. Remember I'm still not finished so I don't work perfectly.")
speak("If you don't know how I work, say 'Help' and I'll tell you what to do.")

speak("DEBUG: READY TO RECEIVE MESSAGES", 0, true)
while true do
	local e, s, p, m = os.pullEvent("chat_message")
	speak("DEBUG: RECEIVED MESSAGE", 0, true)
	local cmdRan = false

	for i = 1, table.getn(commands) do
		if string.lower(m) == commands[i].name then
			commandFuncs[i](i, os.time())
			cmdRan = true
			os.sleep(0.1)
			break
		end
	end

	if not cmdRan and speaking then
		reply = bot:send(m)
		speak(reply, m)
	end
end
