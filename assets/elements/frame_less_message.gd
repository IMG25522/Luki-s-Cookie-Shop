extends Label

var per_spd = 0.02 # time for each character to pop: 0.1s
var stop
signal done

func load_words(thing):#Starting load words
	stop = false
	text = ""
	for i in range(len(thing)):
		await pub.sleep(per_spd)
		if(stop):
			break
		text += thing[i]
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	done.emit()
	
func load_full(thing):
	text = thing
	done.emit()
	stop = true

func clear():
	text = ""
	stop = false
