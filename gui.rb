#!/usr/bin/ruby
require File.expand_path('../gold_digger.rb', __FILE__)

def hello(name)
	s = "Hello " + name
	s
end

def runTrainAndValidate(x,n,h,step, fun)
	# alert(("**" + x + "!!"))
	xInt = x.to_f
	nInt = n.to_i
	hInt = h.to_i
	stepInt= stepInt.to_f
	if fun=="Logistic" 
		alert("l")
	else
		alert("other")
	end
	ret = findBestIn(xInt,nInt,hInt,stepInt, 20)
	"Naive results: " +  (ret.naive).to_s + "\n" + "Network Results: " + (ret.ann).to_s


end


Shoes.app :width =>500 do
	x=""
	h=""
	n=""
	step=""
	fun=""
	stack do
		flow do
			stack :width => "50%" do
			caption "Training to Validation Ratio:"
			end
			stack :width => "50%" do
				x=edit_line
			end
		end
		flow do
			stack :width => "50%" do
				caption "Nodes per Hidden Layer:"
			end
			stack :width => "50%" do
				n=edit_line
			end
		end
		flow do
			stack :width => "50%" do
				caption "Number of Hidden Layers:"
			end
			stack :width => "50%" do
				h=edit_line
			end
		end
		flow do
			stack :width => "50%" do
				caption "Learning Rate:"
			end
			stack :width => "50%" do
				step=edit_line
			end
		end
		flow do
			stack :width => "50%" do
				caption "Transition Function:"
			end
			stack :width => "50%" do
				fun=list_box :items => ["Logistic", "Trans1", "Trans2" ]
			end
		end
		flow do
			style(:margin_left => '40%', :margin_top => '10%', :margin_bottom => '10%')
			button "Submit" do 
				@p.clear { (para "Results: \n" +  runTrainAndValidate(x.text,n.text,h.text,step.text, fun.text))}
			end
		end
		flow :width => 470, :margin => 15, :height => 100 do
			background '#d4d8c9'
			border black, :strokewidth => 2
			@p=flow
		end
	end
end


