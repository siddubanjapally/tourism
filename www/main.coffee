app = @app || {}
app.dbinit()
document.addEventListener "deviceready", (->
  app.dbinit()
  #console.log app
), false
onError = (tx, err) ->
  console.log err.message
toArray = (result) ->
  len = result.rows.length
  result.rows.item(i) for i in [0...len]
districtModel = kendo.observable
  placeId:''
  districtDS: new kendo.data.DataSource
    transport:
      read:(options) ->
        app.db.transaction (tx) ->
          tx.executeSql "select DistId,DistName,DistImgpath from district", [], ((tx, result) ->
            options.success toArray(result)
          ), onError
  districtPlacesDS : new kendo.data.DataSource
    transport:
      read:(options)->
        app.db.transaction (tx)->
          tx.executeSql 'select * from places',[], ((tx,result)->
            options.success toArray(result)

          ),onError

this.placesDatashow = (e)->
  id = e.view.params['id']
  districtModel.districtPlacesDS.filter( { field: "DistName", operator: "startswith", value: id })
this.placeDescDatashow = (e)->
  id = e.view.params['id']
  districtModel.set('placeId',id)
  console.log id
  districtModel.districtPlacesDS.filter( { field: "PlaceName", operator: "startswith", value: id })
  console.log districtModel.districtPlacesDS
  $("#panelbar").kendoPanelBar({
    expandMode: "single"
  })
this.gallaryDatashow = (e)->
  id=districtModel.placeId
  districtModel.districtPlacesDS.filter( { field: "PlaceName", operator: "startswith", value: id })

kendo.bind document.body, districtModel
