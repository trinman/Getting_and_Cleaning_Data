# Run Analysis 
# Get and extract data 
getwd()
full_data = numeric()
training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Make meaningful feature names 
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge training and test sets together
full_data = rbind(training, testing)
# Extract only the measurements on the mean and standard deviation for each measurement.
specific_cols <- grep(".*Mean.*|.*Std.*", features[,2])
# Restrict features to specific columns
features <- features[specific_cols,]
# Addlast two columns (subject and activity)
specific_cols <- c(specific_cols, 562, 563)
# Remove unwanted columns from full_data
full_data <- full_data[,specific_cols]
# Add the column names (features) to full_data
colnames(full_data) <- c(features$V2, "Activity", "Subject")
colnames(full_data) <- tolower(colnames(full_data))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  full_data$activity <- gsub(currentActivity, currentActivityLabel, full_data$activity)
  currentActivity <- currentActivity + 1
}

full_data$activity <- as.factor(full_data$activity)
full_data$subject <- as.factor(full_data$subject)

tidy = aggregate(full_data, by=list(activity = full_data$activity, subject=full_data$subject), mean)
# Remove unnecessary columns 
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
tidy
# Check tidy.txt data
data_check <- function() {
  read.table("tidy.txt", header = TRUE)
}