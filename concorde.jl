using Concorde
include("common_function.jl")


function experiment(n_instances, n_cities)
    lengths = Float64[]
    times = Float64[]

    for i in 1:n_instances
        rng = MersenneTwister(i)
        X = 1000 * rand(rng, n_cities)
        Y = 1000 * rand(rng, n_cities)

        start_time = time()
        opt_tour, opt_len = solve_tsp(X, Y; dist="EUC_2D")
        end_time = time()
        elapsed_time = end_time - start_time

        adjusted_opt_len = opt_len / 1000
        push!(lengths, adjusted_opt_len)
        push!(times, elapsed_time)
    end

    avg_length = mean(lengths)
    std_length = std(lengths)
    avg_time = mean(times)
    std_dev_time = std(times)

    return avg_length, std_length, avg_time, std_dev_time
end

function experiment_concorde(instances_list, cities_list)
    for n_inst in instances_list
        for n_city in cities_list
            avg_length, std_length, avg_time, std_dev_time = experiment(n_inst, n_city)
            
            println("Concorde: Results for N = $n_city cities with $n_inst instances:")
            println("Average Length: $(round(avg_length, digits=3))")
            println("Std Dev of Length: $(round(std_length, digits=3))")
            println("Average Time: $(round(avg_time, digits=3)) s")
            println("Std Dev of Time: $(round(std_dev_time, digits=3)) s")
            println()
        end
    end
end


#experiment_concorde([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], [20, 50, 100])