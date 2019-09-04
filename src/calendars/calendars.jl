

"""
A calendar with no holidays. But account for weekends.

`isholiday` always returns false for this calendar.
Remember that `isbday` considers that Saturdays and Sundars are not business days.
"""
struct WeekendsOnly <: HolidayCalendar end
isholiday(::WeekendsOnly, dt::Dates.Date) = false
function bdayscount(::WeekendsOnly, dt0::Dates.Date, dt1::Dates.Date)
    swapped = false
    if (dt0 == dt1)
        return 0
    elseif (dt0 > dt1)
        dt1, dt0 = dt0, dt1
        swapped = true
    end

    count = 0
    days = (dt1 - dt0).value
    whole_weeks = div(days, 7)
    count += whole_weeks * 5
    
    dt0 += Dates.Day(whole_weeks * 7)
    
    if (dt0 < dt1)
        day_of_week = Dates.dayofweek(dt0)

        while (dt0 < dt1)
            if day_of_week < 6
                count += 1
            end
            dt0 += Dates.Day(1)
            day_of_week += 1
            if (day_of_week == 8)
                day_of_week = 1
            end
        end
    end

    if swapped
        count = -count
    end

    count
end

"""
A calendar with no holidays and no weekends.
`bdays` returns the actual days between dates (`dt1 - d10`).
"""
struct NullHolidayCalendar <: HolidayCalendar end

isholiday(::NullHolidayCalendar, dt::Dates.Date) = false
isbday(::NullHolidayCalendar, dt::Dates.Date) = true
bdays(::NullHolidayCalendar, dt0::Dates.Date, dt1::Dates.Date) = dt1 - dt0

include("australia.jl")
include("brazil.jl")
include("canada.jl")
include("target.jl")
include("uk.jl")
include("us.jl")
