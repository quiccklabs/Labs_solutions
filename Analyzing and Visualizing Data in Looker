

TASK 1:-

# Place in `faa` model
explore: +airports { 
    query: start_from_here {
      measures: [average_elevation]
    }
  }



TASK 2:-

# Place in `faa` model
explore: +airports {
    query: start_from_here {
      dimensions: [facility_type]
      measures: [average_elevation, count]
  }
}




TASK 3:-

# Place in `faa` model
explore: +flights {
    query: start_from_here {
      dimensions: [depart_week]
      measures: [cancelled_count]
      filters: [flights.depart_date: "2004"]
  }
}



TASK 4:- 

# Place in `faa` model
explore: +flights {
    query: start_from_here {
      dimensions: [depart_week, distance_tiered]
      measures: [count]
      filters: [flights.depart_date: "2003"]
  }
}






