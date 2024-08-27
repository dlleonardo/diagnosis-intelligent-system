/*
Symptoms of the virus varied in severity from being asymptomatic to having more than one symptom. 
The most common symptoms were fever, persistent dry cough, and tiredness. 
Less common symptoms were aches and pains, sore throat, diarrhoea, conjunctivitis, headache, 
anosmia/hyposmia (total/partial loss of sense of smell and taste), and running nose. 
Serious symptoms included difficulty breathing or shortness of breath, chest pain or feeling of chest pressure, loss of speech or movement. 
People with serious symptoms needed to seek immediate medical attention, proceeding with an initial assessment call (no contacts) 
to the doctor or health facility. 
People with mild symptoms had to manage their symptoms at home, without a doctor assessment. 
Elderly people (above 70 years old) and those with pre-existent health conditions (e.g. hypertension, diabetes, cardiovascular disease, 
chronic respiratory disease and cancer) were considered more at risk of developing severe symptoms. 
Males in these groups also appeared to be at a slightly higher risk than females. Most infected people developed mild to moderate illness 
and recovered without hospitalization.
*/
/* knowledge base of the system */
/* common symptoms */
commonSymptom(fever).
commonSymptom(dryCough).
commonSymptom(tiredness).

commonSymptoms([fever, dryCough, tiredness]).

/* rare/less common symptoms */
rareSymptom(achesAndPains).
rareSymptom(soreThroat).
rareSymptom(diarrhoea).
rareSymptom(conjunctivitis).
rareSymptom(headache).
rareSymptom(anosmia).
rareSymptom(runningNose).

rareSymptoms([achesAndPains, soreThroat, diarrhoea, conjunctivitis, headache, anosmia, runningNose]).

/* serious symptoms */
seriousSymptom(difficultyBreathing).
seriousSymptom(shortnessOfBreath).
seriousSymptom(feelingOfChestPressure).
seriousSymptom(chestPain).
seriousSymptom(lossOfSpeech).
seriousSymptom(lossOfMovement).

seriousSymptoms([difficultyBreathing, shortnessOfBreath, feelingOfChestPressure, chestPain, lossOfSpeech, lossOfMovement]).

/* patient conditions/risks */
highRisk(elderly). /* age above 70 years old */
highRisk(preExistingHealthConditions).
slightlyHigherRisk(male).

/* the patient has been in contact with someone infected in the past few days */
hasMetSomeoneInfected(yes).

/* rules of the system */
/* this rule checks whether a patient is at high risk or not */
highRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS) :- 
    (highRisk(AGE); highRisk(EXISTING_HEALTH_CONDITIONS)),
    !.

/* this rule checks whether a patient is slightly at a higher risk or not */
slightlyHigherRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS, SEX) :-
    highRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS),
    slightlyHigherRisk(SEX).

/* diagnosis rules */
hasCommonSymptoms(SYMPTOMS) :-
    commonSymptoms(COMMON),
    member(S, SYMPTOMS),
    member(S, COMMON).

hasRareSymptoms(SYMPTOMS) :- 
    rareSymptoms(RARE),
    member(S, SYMPTOMS),
    member(S, RARE).

hasSeriousSymptoms(SYMPTOMS) :-
    seriousSymptoms(SERIOUS),
    member(S, SYMPTOMS),
    member(S, SERIOUS).

diagnose(SYMPTOMS, AGE, EXISTING_HEALTH_CONDITIONS, SEX, CONTACT) :- 
    P_I is 0,
    (hasCommonSymptoms(SYMPTOMS); hasRareSymptoms(SYMPTOMS); hasSeriousSymptoms(SYMPTOMS)),
    hasMetSomeoneInfected(CONTACT) -> P_I_1 is P_I + 0.4,
    write('You are infected: '), write(P_I_1),
    !.
