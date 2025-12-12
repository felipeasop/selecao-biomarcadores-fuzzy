library(GA)

fitness_fun <- function(bin_val) {
    x <- binary2decimal(bin_val)
    return(2 * x ^ 2 + 3 * x)
}

ga_solution <- ga(
    type = "binary",
    fitness = fitness_fun,
    nBits = 8,       
    popSize = 50,   
    maxiter = 100,     
    run = 50,      
    pcrossover = 0.45, 
    pmutation = 0.05,  
    elitism = 2        
)

summary(ga_solution)

best_bin <- ga_solution@solution[1, ]
best_val <- ga_solution@fitnessValue
best_x <- binary2decimal(best_bin)

cat("\nMelhor cromossomo (binário):", best_bin, "\n")
cat("Valor de x:", best_x, "\n")
cat("Máximo de f(x):", best_val, "\n")