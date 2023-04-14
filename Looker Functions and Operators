



TASK 1:-

# Place in `faa` model
explore: +flights {
  query: start_from_here{
      dimensions: [depart_week, distance_tiered]
      measures: [count]
      filters: [flights.depart_date: "2003"]
    }
  }

TASK 2:-

# Place in `faa` model
explore: +flights {
  query: start_from_here{
      dimensions: [aircraft_origin.state]
      measures: [percent_cancelled]
      filters: [flights.depart_date: "2000"]
    }
  }


TASK 3:-

# Place in `faa` model
explore: +flights {
    query: start_from_here{
      dimensions: [aircraft_origin.state]
      measures: [cancelled_count, count]
      filters: [flights.depart_date: "2004"]
    }
}


TASK 4:-

# Place in `faa` model
explore: +flights {
    query: start_from_here{
      dimensions: [carriers.name]
      measures: [total_distance]
    }
}


TASK 5:-

# Place in `faa` model
explore: +flights {
    query:start_from_here {
      dimensions: [depart_year, distance_tiered]
      measures: [count]
      filters: [flights.depart_date: "after 2000/01/01"]
    }
}





