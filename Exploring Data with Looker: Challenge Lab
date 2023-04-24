Look 1:-


explore: +airports {
     query: start_from_here{
      dimensions: [city, state]
      measures: [count]
      filters: [airports.facility_type: "HELIPORT^ ^ ^ ^ ^ ^ ^ "]
    } 
}



Look 2:-


explore: +airports {
    query: start_from_here{
      dimensions: [facility_type, state]
      measures: [count]
    }
  }




Look 3:-


explore: +flights {
    query: start_from_here{
      dimensions: [aircraft_origin.city, aircraft_origin.state]
      measures: [cancelled_count, count]
    }
}
























