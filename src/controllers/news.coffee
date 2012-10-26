#fakeout, since we're not connecting to an API or database or anything
data = [
         { id: 0, title: "News Post", body: "This is a test news post, cool." }
         { id: 1, title: "News Post", body: "This is another test news post, cool." }
       ]

data_id = data.length

news =
  get: (id) ->
    if id
      id = id*1

      record = null
      i = -1

      for n, index in data
        if n.id == id
          record = n
          i = index
          record.index = i
          break

      record
    else
      data

  save: (record) ->
    if record.id
      data[id] = record
    else
      record.id = data_id
      data.push(record)
      data_id++

    record

  delete: (id) ->
    record = news.get(id)

    if record
      data.splice(record.index, 1)
      record
    else
      { error: "record not found", data: { id: id } }

module.exports =
  get: news.get
  save: news.save
  delete: news.delete
