require 'json'
def register(params)
end

def filter(event)
  message = JSON.parse(event.get("[message]"))
  operation = message["payload"]["op"]
  if operation == "c" || operation == "u"
    record =  message["payload"]["after"]
  else
    record = message["payload"]["before"]
  end
  record.each do |k,v|
    event.set(k,v)
  end
    event.set("[@action]", operation_name(operation))
  return [event]
end

def operation_name(operation)
  return "create" if operation == "c"
  return "update" if operation == "u"
  return "delete"
end
