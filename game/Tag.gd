extends Node
class_name Tag


# Check.new(Obj.getTags()).Or(All("blue","flat").Any("tasty","boring"),Not("fishy"))

var tagsToCheck:Array[String]=[]

func setTagsToCheck(tags):
	tagsToCheck=tags

func Any():
	pass

func Or():
	pass
