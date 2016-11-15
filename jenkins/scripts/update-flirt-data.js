// update flight counts ----------------------------------------------------------

db.legs.ensureIndex({effectiveDate: 1})
db.legs.ensureIndex({discontinuedDate: -1})

var startDate = db.legs.find().sort({effectiveDate: 1}).limit(1).toArray()[0].effectiveDate
startDate.setUTCHours(0,0,0,0)
var endDate = db.legs.find().sort({discontinuedDate: -1}).limit(1).toArray()[0].discontinuedDate
print(startDate, endDate)
db.flightCounts.remove({}) //clear out the flightCounts collection
while(startDate < endDate){
  var counts = db.legs.find(
      {
        effectiveDate: {$lte: startDate},
        discontinuedDate: {$gte: startDate}
      }
    ).count()
  db.flightCounts.insert({date: startDate, count: counts})
  printjson({date: startDate, count: counts})
  startDate.setHours(startDate.getHours() + 25) //need to do this to account for daylight savings time
  startDate.setUTCHours(0,0,0,0)
}

// update day counts --------------------------------------------------------------
db.legs.ensureIndex({day1:1})
db.legs.ensureIndex({day2:1})
db.legs.ensureIndex({day3:1})
db.legs.ensureIndex({day4:1})
db.legs.ensureIndex({day5:1})
db.legs.ensureIndex({day6:1})
db.legs.ensureIndex({day7:1})

var dayCounts = db.legs.aggregate([
  {"$project": 
    { "mondayNum": {"$cond": ["$day1",1,0]},
      "tuesdayNum":{"$cond": ["$day2",1,0]},
      "wednesdayNum":{"$cond": ["$day3",1,0]},
      "thursdayNum":{"$cond": ["$day4",1,0]},
      "fridayNum":{"$cond": ["$day5",1,0]},
      "saturdayNum":{"$cond": ["$day6",1,0]},
      "sundayNum":{"$cond": ["$day7",1,0]}
    }
  },
  {"$group": 
    {
      "_id": null,
      "monday":{
        "$sum":"$mondayNum"
      },
      "tuesday":{
        "$sum":"$tuesdayNum"
      },
      "wednesday":{
        "$sum":"$wednesdayNum"
      },
      "thursday":{
        "$sum":"$thursdayNum"
      },
      "friday":{
        "$sum":"$fridayNum"
      },
      "saturday":{
        "$sum":"$saturdayNum"
      },
      "sunday":{
        "$sum":"$sundayNum"
      }
    }   
  }
]).toArray()
db.dayCounts.remove({});
db.dayCounts.insert({day: "Monday", count: dayCounts[0].monday})
db.dayCounts.insert({day: "Tuesday", count: dayCounts[0].tuesday})
db.dayCounts.insert({day: "Wednesday", count: dayCounts[0].wednesday})
db.dayCounts.insert({day: "Thursday", count: dayCounts[0].thursday})
db.dayCounts.insert({day: "Friday", count: dayCounts[0].friday})
db.dayCounts.insert({day: "Saturday", count: dayCounts[0].saturday})
db.dayCounts.insert({day: "Sunday", count: dayCounts[0].sunday})

// db.legs.dropIndex({day1:1})
// db.legs.dropIndex({day2:1})
// db.legs.dropIndex({day3:1})
// db.legs.dropIndex({day4:1})
// db.legs.dropIndex({day5:1})
// db.legs.dropIndex({day6:1})
// db.legs.dropIndex({day7:1})


// update airport counts -----------------------------------------------------------
// I looked at doing this all in one query but it was so giant and complicated that I decided to 
// break it up into multiple queries to simplify things. 
// Related: http://stackoverflow.com/questions/36363112/grouping-and-counting-across-documents

// insert the base records with a departure count
db.legs.aggregate([
  {
    "$group":{
      _id: "$departureAirport._id",
      departureCount: {$sum: 1}
    }
  }
]).forEach(function(airport){
  db.airportCounts.insert(airport)
});

// add in the arrival counts
db.legs.aggregate([
  {
    "$group":{
      _id: "$arrivalAirport._id",
      arrivalCount: {$sum: 1}
    }
  }
]).forEach(function(airport){
  db.airportCounts.update({_id: airport._id}, {$set: {arrivalCount: airport.arrivalCount}})
});

// get the total of arrivals + departures
db.airportCounts.aggregate(
   [
     {
       $project:
         { 
           totalAmount: { $add: [ "$arrivalCount", "$departureCount" ] }
         }
     }
   ]
).forEach(function(airport){
  db.airportCounts.update({_id: airport._id}, {$set: {total: airport.totalAmount}})
})
