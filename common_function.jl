using Random, Distances, Statistics, Plots

function generate_random_coordinates(n_cities, seed)
    rng = MersenneTwister(seed)
    return rand(rng, n_cities, 2)
end

function create_distance_matrix(coords)
    return pairwise(Euclidean(), coords, dims=1)
end

function calculate_cost(dist_matrix, tour)
    tour_length = 0
    for i in 1:length(tour)-1
        tour_length += dist_matrix[tour[i], tour[i+1]]
    end
    tour_length += dist_matrix[tour[end], tour[1]]
    return tour_length
end

function two_opt_swap!(tour, i, j)
    new_tour = copy(tour)
    new_tour[1:i] = tour[1:i]
    new_tour[i+1:j] = reverse(tour[i+1:j])
    new_tour[j+1:end] = tour[j+1:end]
    return new_tour
end