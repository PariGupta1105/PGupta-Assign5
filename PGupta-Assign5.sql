#1. How many containers of antibiotics are currently available?
SELECT item.quantityOnHand
FROM item
WHERE item.itemDescription = 'bottle of antibiotics';
#2. Which volunteer(s), if any, have phone numbers that do not start with the number 2 and whose
#last name is not Jones. Query should retrieve names rather than ids.
SELECT volunteer.volunteerName
FROM volunteer
WHERE volunteer.volunteerTelephone NOT LIKE '2%' AND volunteer.volunteerName NOT LIKE '%Jones';
#3. Which volunteer(s) are working on transporting tasks? Query should retrieve names rather than ids.
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
JOIN task ON task.taskCode = assignment.taskCode
JOIN task_type ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName = 'transporting';
#4. Which task(s) have yet to be assigned to any volunteers (provide task descriptions, not the codes)?
SELECT task.taskDescription
FROM task
LEFT JOIN assignment ON assignment.taskCode = task.taskCode
WHERE assignment.taskCode IS NULL;
#5. Which type(s) of package contain some kind of bottle?
SELECT DISTINCT package_type.packageTypeName
FROM item 
JOIN package_contents ON item.itemId = package_contents.itemId
JOIN package ON package.packageId = package_contents.packageId
JOIN package_type ON package.packageTypeId = package_type.packageTypeId
WHERE item.itemDescription LIKE '%bottle%';
#6. Which items, if any, are not in any packages? Answer should be item descriptions.
SELECT item.itemDescription
FROM item
LEFT JOIN package_contents ON item.itemId = package_contents.itemId
WHERE package_contents.itemId IS NULL;
#7. Which task(s) are assigned to volunteer(s) that live in New Jersey (NJ)? Answer should have the
#task description and not the task ids.
SELECT DISTINCT task.taskDescription
FROM task 
JOIN assignment ON task.taskCode = assignment.taskCode
JOIN volunteer ON assignment.volunteerId = volunteer.volunteerId
WHERE volunteer.volunteerAddress LIKE '%NJ%';
#8. Which volunteers began their assignments in the first half of 2021? Answer should have the
#volunteer names and not their ids.
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
WHERE assignment.startDateTime BETWEEN '2021-01-01' AND '2021-07-01';
#9. Which volunteers have been assigned to tasks that include packing spam? Answer should have
#the volunteer names and not their ids.
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment ON assignment.volunteerId = volunteer.volunteerId
JOIN task ON assignment.taskCode = task.taskCode
JOIN task_type ON task_type.taskTypeId = task.taskTypeId
JOIN package ON package.taskCode = task.taskCode
JOIN package_contents ON package.packageId = package_contents.packageId
JOIN item ON package_contents.itemId = item.itemId
WHERE task_type.taskTypeName = 'packing' AND item.itemDescription = 'can of spam';
#10. Which item(s) (if any) have a total value of exactly $100 in one package? Answer should be item descriptions.
SELECT item.itemDescription
FROM item 
JOIN package_contents ON package_contents.itemId = item.itemId
WHERE item.itemValue * package_contents.itemQuantity = 100;
#11. How many volunteers are assigned to tasks with each different status? The answer should show
#each different status and the number of volunteers sorted from highest to lowest.
SELECT task_status.taskStatusName, COUNT(DISTINCT assignment.volunteerId) AS volunteerCount
FROM assignment 
JOIN task ON assignment.taskCode = task.taskCode 
JOIN task_status ON task_status.taskStatusId = task.taskStatusId
GROUP BY task_status.taskStatusName
ORDER BY volunteerCount DESC;
#12. Which task creates the heaviest set of packages and what is the weight? Show both the
#taskCode and the weight (You should be able to do this without using any sub-queries).
SELECT task.taskCode, SUM (package.packageWeight) AS totalWeight
FROM task
JOIN package ON package.taskCode = task.taskCode
GROUP BY task.taskCode
ORDER BY totalWeight DESC
LIMIT 1;
#13. How many tasks are there that do not have a type of "packing"?
SELECT COUNT (task_type.taskTypeName) AS taskTypeNo
FROM task
JOIN task_type ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName NOT LIKE '%packing%'
ORDER BY task_type.taskTypeName;
#14. Of those items that have been packed, which item (or items) were touched by fewer than 3
#volunteers? Answer should be item descriptions.
SELECT item.itemDescription
FROM item 
JOIN package_contents ON item.itemId = package_contents.itemId
JOIN package ON package_contents.packageId = package.packageId
JOIN assignment ON assignment.taskCode = package.taskCode
GROUP BY item.itemDescription
HAVING COUNT (DISTINCT assignment.volunteerId) < 3;
#15. Which packages have a total value of more than 100? Show the packageIds and their value
#sorted from lowest to highest.
SELECT package.packageId, SUM(item.itemValue * package_contents.itemQuantity) AS packageTotalValue
FROM item
JOIN package_contents ON item.itemId = package_contents.itemId
JOIN package ON package.packageId = package_contents.packageId
GROUP BY package.packageId
HAVING packageTotalValue > 100
ORDER BY packageTotalValue ASC;

