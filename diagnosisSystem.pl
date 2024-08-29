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
/* list of common symptoms */
commonSymptoms([fever, dryCough, tiredness]).

/* list of rare/less common symptoms */
rareSymptoms([achesAndPains, soreThroat, diarrhoea, conjunctivitis, headache, anosmia, runningNose]).

/* list of serious symptoms */
seriousSymptoms([difficultyBreathing, shortnessOfBreath, feelingOfChestPressure, chestPain, lossOfSpeech, lossOfMovement]).

/* patient conditions/risks */
slightlyHigherRisk(male).

/* the patient has been in contact with someone infected in the past few days */
metSomeoneInfected(yes).

/* rules of the system */
/* artithmetic and lists 5.3 */
len([],0).
len([_|T],N) :- 
    len(T,X), 
    N is X+1.

/* checks whether a patient is a high risk patient or not */
highRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS) :- 
    AGE > 70; 
    len(EXISTING_HEALTH_CONDITIONS, N),
    N > 0.

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

    /* if the patient has at least one common or serious symptom, increase P(I) by 50% */
    ((hasCommonSymptoms(SYMPTOMS); hasSeriousSymptoms(SYMPTOMS)) -> P_S is P_I + 0.5; P_S is P_I),
    
    /* if the patient has at least one rare symptom and no common or serious symptom, increase P(I) by 20% */
    ((P_S == 0, hasRareSymptoms(SYMPTOMS)) -> P_S_2 is P_S + 0.2; P_S_2 is P_S), 

    /* if the patient is a high risk patient (elderly or with pre-existing health conditions), increase P(I) by 8% */    
    (highRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS) -> P_R is P_S_2 + 0.08; P_R is P_S_2),
    
    /* if the patient belongs to one of the two previous groups and is a male, increase P(I) by 2% */
    (slightlyHigherRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS, SEX) -> P_S_R is P_R + 0.02; P_S_R is P_R),
    
    /* if the patient has met someone infected in the past few days, increase P(I) by 40% */
    (metSomeoneInfected(CONTACT) -> P_C is P_S_R + 0.4; P_C is P_S_R),
    
    /* print the diagnose output based on P(I) value */
    (P_C >= 0.5 -> write('You are infected: '), write(P_C); write('You are not infected.')),
    !.
