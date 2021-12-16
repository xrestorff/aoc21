-- part one
with parsed as (
    select trim(split_part(input, '|', 2)) as output
    from day08
),
     digits as (
         select *,
                length(split_part(output, ' ', 1)) as len1,
                length(split_part(output, ' ', 2)) as len2,
                length(split_part(output, ' ', 3)) as len3,
                length(split_part(output, ' ', 4)) as len4
         from parsed
     ),
     uniqueness as (
         select *,
                len1 in (2, 4, 3, 7) as is_unique1,
                len2 in (2, 4, 3, 7) as is_unique2,
                len3 in (2, 4, 3, 7) as is_unique3,
                len4 in (2, 4, 3, 7) as is_unique4
         from digits)
select sum(is_unique1 ::int + is_unique2 ::int + is_unique3 ::int + is_unique4 ::int)
from uniqueness;

-- part two
with recursive
    digits(digit, letters) as (values (0, 'abcefg'),
                                      (1, 'cf'),
                                      (2, 'acdeg'),
                                      (3, 'acdfg'),
                                      (4, 'bcdf'),
                                      (5, 'abdfg'),
                                      (6, 'abdefg'),
                                      (7, 'acf'),
                                      (8, 'abcdefg'),
                                      (9, 'abcdfg')
    ),
    letters as (
        select *, length(letters) as len, unnest(regexp_split_to_array(letters, '')) as letter
        from digits
        order by 3),
    letter_freq as (
        select letter, string_agg(len::text, '') as freqs
        from letters
        group by 1),
    add_input_id as (
        select *, row_number() over () as id
        from day08
    ),
    parsed_inputs as (
        select id, input, 1 as pos, split_part(input, ' ', 1) as letters
        from add_input_id
        union all
        select id, input, pos + 1, split_part(input, ' ', pos + 1)
        from parsed_inputs
        where pos
                  < 10
    )
        ,
    sorted_inputs as (
        select id, pos, string_agg(letter, '') as letters
        from (
                 select id, pos, unnest(regexp_split_to_array(letters, '')) as letter
                 from parsed_inputs
                 order by 1, 2, 3) as split
        group by 1, 2
    ),
    input_letters as (
        select id, length(letters) as len, unnest(regexp_split_to_array(letters, '')) as letter
        from sorted_inputs
        order by 2
    ),
    input_letter_freq as (
        select id, letter, string_agg(len::text, '') as freqs
        from input_letters
        group by 1, 2
    ),
    letter_mapping as (
        select inputs.id, orig.letter as orig_letter, inputs.letter as input_letter
        from input_letter_freq as inputs
                 inner join letter_freq as orig
                            on inputs.freqs = orig.freqs),
    input_letter_mapping as (
        select letter_mapping.id, sorted_inputs.letters, letter_mapping.orig_letter, letter_mapping.input_letter
        from letter_mapping
                 inner join sorted_inputs
                            on letter_mapping.id = sorted_inputs.id
                                and sorted_inputs.letters like ('%' || letter_mapping.input_letter || '%')
        order by 1, 2, 3),
    input_letters_mapping as (
        select id, letters as input_letters, string_agg(orig_letter, '') as orig_letters
        from input_letter_mapping
        group by 1, 2
    ),
    outputs as (
        select id, trim(split_part(input, '|', 2)) as output
        from add_input_id
    ),
    parsed_outputs as (
        select id,
               output,
               1                          as pos,
               split_part(output, ' ', 1) as letters
        from outputs
        union all
        select id,
               output,
               pos + 1,
               split_part(output, ' ', pos + 1)
        from parsed_outputs
        where pos
                  < 4
    )
        ,
    sorted_outputs as (
        select id, pos, string_agg(letter, '') as letters
        from (
                 select id, pos, unnest(regexp_split_to_array(letters, '')) as letter
                 from parsed_outputs
                 order by 1, 2, 3) as split
        group by 1, 2
    ),
    actual_outputs as (
        select sorted_outputs.*, input_letters_mapping.orig_letters as actual_letters, digits.digit
        from sorted_outputs
                 inner join input_letters_mapping
                            on sorted_outputs.id = input_letters_mapping.id
                                and sorted_outputs.letters = input_letters_mapping.input_letters
                 inner join digits on input_letters_mapping.orig_letters = digits.letters
        order by 1, 2
    ),
    actual_numbers as (
        select id, string_agg(digit::text, ''):: int as result
        from actual_outputs
        group by 1
    )
select sum(result)
from actual_numbers;