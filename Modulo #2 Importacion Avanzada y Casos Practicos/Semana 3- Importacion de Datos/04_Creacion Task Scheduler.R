

### Instalamos el paquete. 
#install.packages("taskscheduleR")
library(taskscheduleR)


## Correr todos los dias empezando mañana a las 9:10 AM 
taskscheduler_create(taskname = "correr_TC", rscript = "C:/Users/andre/Documents/tasks/TC_BC_daily.R", 
                    schedule = "DAILY", starttime = "09:10", startdate = format(Sys.Date()+1, "%m/%d/%Y"))

##Eliminar el proceso
# taskscheduler_delete(taskname = "correr_TC")

