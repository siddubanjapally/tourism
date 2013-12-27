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
  placeName: ''
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
  galleryDS : new kendo.data.DataSource
    transport:
      read:(options)->
        app.db.transaction (tx)->
          tx.executeSql 'select * from gallery',[], ((tx,result)->
            options.success toArray(result)
          ),onError
  hotelsDS : new kendo.data.DataSource
    transport:
      read:(options)->
        app.db.transaction (tx)->
          tx.executeSql 'select * from hotels',[], ((tx,result)->
            options.success toArray(result)
          ),onError

this.placesClick = (e)->
  id = e.dataItem.PlaceName
  districtModel.set 'placeName',id
this.placesDatashow = (e)->
  id = e.view.params['id']
  districtModel.districtPlacesDS.filter( { field: "DistName", operator: "startswith", value: id })
this.placeDescDatashow = (e)->
  districtModel.districtPlacesDS.filter( { field: "PlaceName", operator: "startswith", value: districtModel.placeName })
  $("#panelbar").kendoPanelBar({
    expandMode: "single"
  })
this.galleryDatashow=(e)->
  districtModel.galleryDS.filter( { field: "PlaceName", operator: "startswith", value:  districtModel.placeName })
this.hotelsDatashow=(e)->
  districtModel.hotelsDS.filter( { field: "PlaceName", operator: "startswith", value:  districtModel.placeName })
kendo.bind document.body, districtModel