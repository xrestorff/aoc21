-- part one
with recursive
    add_board_num as (
        select ceiling(row_number() over () / 5.0) as board, *
        from day04_boards
    ),
    add_row_nums as (
        select number,
               row_number() over () as row_num
        from day04_numbers
    ),
    game as (
        select *,
               false as mark1,
               false as mark2,
               false as mark3,
               false as mark4,
               false as mark5,
               0     as num_count
        from add_board_num
        union all
        select game.board,
               game.input1,
               game.input2,
               game.input3,
               game.input4,
               game.input5,
               game.mark1 or game.input1 = numbers.number,
               game.mark2 or game.input2 = numbers.number,
               game.mark3 or game.input3 = numbers.number,
               game.mark4 or game.input4 = numbers.number,
               game.mark5 or game.input5 = numbers.number,
               num_count + 1
        from game
                 inner join add_row_nums as numbers
                            on (game.num_count + 1) = numbers.row_num
    ),
    round_scores as (
        select *,
               sum(mark1::int) over w                                         as col1_sum,
               sum(mark2::int) over w                                         as col2_sum,
               sum(mark3::int) over w                                         as col3_sum,
               sum(mark4::int) over w                                         as col4_sum,
               sum(mark5::int) over w                                         as col5_sum,
               mark1::int + mark2::int + mark3::int + mark4::int + mark5::int as row_sum
        from game
            window w as (partition by num_count, board)
    ),
    winners as (
        select *
        from round_scores
        where row_sum = 5
           or col1_sum = 5
           or col2_sum = 5
           or col3_sum = 5
           or col4_sum = 5
           or col5_sum = 5
    ),
    winning_round as (select min(num_count) as num_count from winners),
    winning_board as (
        select distinct board
        from winners
        where num_count = (select num_count from winning_round)
    ),
    winning_score as (
        select *,
               (not mark1) ::int * input1 + (not mark2)::int * input2 + (not mark3)::int * input3 +
               (not mark4)::int * input4 +
               (not mark5)::int * input5 as unmarked_sum
        from game
        where board = (select board from winning_board)
          and num_count = (select num_count from winning_round)
    )
select sum(unmarked_sum) * (select number from add_row_nums where row_num = (select num_count from winning_round))
from winning_score;

-- part two
with recursive
    add_board_num as (
        select ceiling(row_number() over () / 5.0) as board, *
        from day04_boards
    ),
    add_row_nums as (
        select number,
               row_number() over () as row_num
        from day04_numbers
    ),
    game as (
        select *,
               false as mark1,
               false as mark2,
               false as mark3,
               false as mark4,
               false as mark5,
               0     as num_count
        from add_board_num
        union all
        select game.board,
               game.input1,
               game.input2,
               game.input3,
               game.input4,
               game.input5,
               game.mark1 or game.input1 = numbers.number,
               game.mark2 or game.input2 = numbers.number,
               game.mark3 or game.input3 = numbers.number,
               game.mark4 or game.input4 = numbers.number,
               game.mark5 or game.input5 = numbers.number,
               num_count + 1
        from game
                 inner join add_row_nums as numbers
                            on (game.num_count + 1) = numbers.row_num
    ),
    round_scores as (
        select *,
               sum(mark1::int) over w                                         as col1_sum,
               sum(mark2::int) over w                                         as col2_sum,
               sum(mark3::int) over w                                         as col3_sum,
               sum(mark4::int) over w                                         as col4_sum,
               sum(mark5::int) over w                                         as col5_sum,
               mark1::int + mark2::int + mark3::int + mark4::int + mark5::int as row_sum
        from game
            window w as (partition by num_count, board)
    ),
    winners as (
        select *
        from round_scores
        where row_sum = 5
           or col1_sum = 5
           or col2_sum = 5
           or col3_sum = 5
           or col4_sum = 5
           or col5_sum = 5
    ),
    first_wins as (
        select board, min(num_count) as num_count
        from winners
        group by 1
    ),
    winning_round as (select max(num_count) as num_count from first_wins),
    winning_board as (
        select board
        from first_wins
        where num_count = (select num_count from winning_round)
    ),
    winning_score as (
        select *,
               (not mark1) ::int * input1 + (not mark2)::int * input2 + (not mark3)::int * input3 +
               (not mark4)::int * input4 +
               (not mark5)::int * input5 as unmarked_sum
        from game
        where board = (select board from winning_board)
          and num_count = (select num_count from winning_round)
    )
select sum(unmarked_sum) * (select number from add_row_nums where row_num = (select num_count from winning_round))
from winning_score;