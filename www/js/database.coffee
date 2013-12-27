app = this.app || {}
homedata = [
  { DistId:1,DistName:'East Sikkim',DistImgpath:'gangtok.jpg'},
  { DistId:2,DistName:'West Sikkim',DistImgpath:'khanchaedzonga.jpg'},
  { DistId:3,DistName:'North Sikkim',DistImgpath:'namchi.jpg'},
  { DistId:4,DistName:'South Sikkim',DistImgpath:'villageTourism.jpg'}
]
InitDatabase =
  tableStatements:{
    district:'CREATE TABLE  IF NOT EXISTS district(DistId,DistName,DistImgpath)'
    places: 'CREATE TABLE  IF NOT EXISTS places(PlaceId INTEGER PRIMARY KEY,PlaceName,PlaceDisc,Imgpath,NearbyPlaces,AboutPlace,DistName)'
    gallery:'CREATE TABLE  IF NOT EXISTS gallery(GalleryId INTEGER PRIMARY KEY,Imgpath,PlaceName)'
    hotels:'CREATE TABLE  IF NOT EXISTS hotels(HotelId INTEGER PRIMARY KEY,HotelName,PlaceName,Address,ContactNo)'
  }
  openDb: ()->
    app.db = openDatabase 'tourismdb','3.8.2','MTourism',20*1024*1024
    InitDatabase.createtables()
  createtables: ()->
    app.db.transaction((tx)->
      tx.executeSql(InitDatabase.tableStatements.district,[],InitDatabase.insertDistrictData,(tx,err)->
        console.log err.message )
      tx.executeSql(InitDatabase.tableStatements.places,[],InitDatabase.insertPlacesData,(tx,err)->
        console.log err.message )
      tx.executeSql(InitDatabase.tableStatements.gallery,[],InitDatabase.insertGalleryData,(tx,err)->
        console.log err.message )
      tx.executeSql(InitDatabase.tableStatements.hotels,[],InitDatabase.insertHotelsData,(tx,err)->
        console.log err.message )
    )
  insertDistrictData:(tr,res) ->
    if res.insertId
      app.db.transaction (tx)->
        homedata.forEach (item)->
          tx.executeSql('INSERT INTO district (DistId,DistName,DistImgpath) VALUES(?,?,?)',[item.DistId,item.DistName,item.DistImgpath])
  insertPlacesData:(tr,res) ->
    if res.insertId
      app.db.transaction (tx)->
        app.data.places.forEach (place)->
          tx.executeSql('INSERT INTO places(PlaceName,PlaceDisc,Imgpath,NearbyPlaces,AboutPlace,DistName) VALUES(?,?,?,?,?,?)',[place.name,place.discription,place.imgPath,place.nearBy,place.about,place.DistName])
  insertGalleryData:(tr,res) ->
    if res.insertId
      app.db.transaction (tx)->
        app.data.gallery.forEach (gall)->
          tx.executeSql('INSERT INTO gallery(Imgpath,PlaceName) VALUES(?,?)',[gall.Imgpath,gall.PlaceName])
  insertHotelsData:(tr,res) ->
    if res.insertId
      app.db.transaction (tx)->
        app.data.hotels.forEach (gall)->
          tx.executeSql('INSERT INTO hotels(HotelName,PlaceName,Address,ContactNo) VALUES(?,?,?,?)',[gall.hotelName,gall.placeName,gall.address,gall.contactNo])
  init: ()->
    InitDatabase.openDb()
app.dbinit = InitDatabase.init
this.app = app