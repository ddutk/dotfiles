function conky_pad2( number )
    return string.format( '%2u' , conky_parse( number ) )
end

function conky_pad3( number )
    return string.format( '%3u' , conky_parse( number ) )
end

function conky_pad31( number )
    return string.format( '%5.1f' , conky_parse( number ) )
end

function conky_pad4( number )
    return string.format( '%4u' , conky_parse( number ) )
end

function conky_pad41( number )
    return string.format( '%6.1f' , conky_parse( number ) )
end
