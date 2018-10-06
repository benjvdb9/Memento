require 'clipboard'

class CareTaker
	attr_accessor :mementos
end

class Memento
	def initialize(clip)
		@clipboard = clip
	end

	def getMemento()
		@clipboard
	end
end

class CurrentClipboard
	@@caretaker = CareTaker.new()
	@@caretaker.mementos = []
	def initialize()
		@clipboard 
	end

	def Copy()
		@clipboard = self.getClipboardContent()
		self.save()
	end

	def Undo()
		self.restore()
		self.setClipboardContent(@clipboard)
	end

	def Status()
		puts @@caretaker.mementos
	end

	def save()
		memento = Memento.new(@clipboard)
		@@caretaker.mementos.push(memento)
	end

	def restore()
		begin
			memento = @@caretaker.mementos.pop()
			if @clipboard == memento.getMemento()
				memento = @@caretaker.mementos.pop()
			end
			@clipboard = memento.getMemento()
		rescue	
			@clipboard = ""
		end
	end

	def setClipboardContent(input)
		#Windows specific, use if necessary
		#`echo | set /p=#{input.chomp} | CLIP`

		Clipboard.copy(input.chomp)
		puts "This is now in the clipboard: #{input.chomp}"
	end

	def getClipboardContent()
		#Windows specific, use if necessary
		#clip = `pastetest.exe`

		clip = Clipboard.paste().encode('UTF-8')
		puts "This is currently in the clipboard: #{clip}"
		clip
	end
end

loop_is_running = true
Clip = CurrentClipboard.new()

if __FILE__ == $0
	while loop_is_running	
		puts "Input command:"
		input = gets.chomp
		case input
		when "c"
			Clip.Copy()
		when "u"
			Clip.Undo()

		#Test fuctions
		when "test"
			Clip.setClipboardContent("Ruby test")
		when "s"
			Clip.Status()
		when "p"
			Clip.getClipboardContent()
		when "exit"
			printf "\nClosing program!"
			loop_is_running = false
		else
			puts "'#{input}' is not a valid command\n"
		end
		puts ""
	end
end
