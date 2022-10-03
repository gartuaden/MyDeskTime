var Reader = (event) => {
    var data = event.target;

    var reader = new FileReader();
    reader.onload = () => {
        var lines = reader.result.split("\n");
        for (var i = 0; i < lines.length; i++){
            var line = lines[i].split(" ");
            var date_ = line[0];
            var goalTime = parseInt(line[1]);
            var studyTime = parseInt(line[2]);


            createBox(date_, studyTime, goalTime);
        }
    };
    reader.readAsText(data.files[0]);
}

var createBox = (date, goal, study) => {
    var studyTimeStr = Math.floor(study / 60) + "h " + study % 60 + "m";
    var goalTimeStr = Math.floor(goal / 60) + "h " + goal % 60 + "m";

    // <div id = "total-box">
    var totalBoxDiv = document.createElement('div');
    totalBoxDiv.setAttribute('id', 'total-box');

    var dateDiv = document.createElement('div');
    if (goal <= study){
        dateDiv.setAttribute('id', 'date');
    }
    else {
        dateDiv.setAttribute('id', 'date-not-done');
    }
    dateDiv.innerHTML = date;

    var timeBoxDiv = document.createElement('div');
    timeBoxDiv.setAttribute('id', 'time-box');


    var studyBoxDiv = document.createElement('div');
    studyBoxDiv.setAttribute('id', 'study-time');

    var studyTitleDiv = document.createElement('div');
    studyTitleDiv.setAttribute('id', 'small-title');
    studyTitleDiv.innerHTML = "STUDY TIME";

    var studyContentDiv = document.createElement('div');
    studyContentDiv.setAttribute('id', 'content-box');

    var study_a = document.createElement('a');
    study_a.innerHTML = studyTimeStr;


    var goalBoxDiv = document.createElement('div');
    goalBoxDiv.setAttribute('id', 'goal-time');

    var goalTitleDiv = document.createElement('div');
    goalTitleDiv.setAttribute('id', 'small-title');
    goalTitleDiv.innerHTML = "GOAL TIME";

    var goalContentDiv = document.createElement('div');
    goalContentDiv.setAttribute('id', 'content-box');

    var goal_a = document.createElement('a');
    goal_a.innerHTML = goalTimeStr;


    studyContentDiv.appendChild(study_a);
    studyBoxDiv.appendChild(studyTitleDiv);
    studyBoxDiv.appendChild(studyContentDiv);

    timeBoxDiv.appendChild(studyBoxDiv);

    goalContentDiv.appendChild(goal_a);
    goalBoxDiv.appendChild(goalTitleDiv);
    goalBoxDiv.appendChild(goalContentDiv);

    timeBoxDiv.appendChild(goalBoxDiv);

    totalBoxDiv.appendChild(dateDiv);
    totalBoxDiv.appendChild(timeBoxDiv);

    document.body.appendChild(totalBoxDiv);
}