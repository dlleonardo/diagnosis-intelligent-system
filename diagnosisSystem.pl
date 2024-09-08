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
/* Learn Prolog Now! - Artithmetic and Lists 5.3 */
len([], 0).
len([_|T], N) :- 
    len(T, X), 
    N is X + 1.

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

/* main rule of the system */
diagnose(SYMPTOMS, AGE, EXISTING_HEALTH_CONDITIONS, SEX, CONTACT) :- 
    P_0 is 0,

    /* if the patient has at least one common or serious symptom, increase P(I) by 50% */
    ((hasCommonSymptoms(SYMPTOMS); hasSeriousSymptoms(SYMPTOMS)) -> P_CS_S is 0.5; P_CS_S is P_0),
    
    /* if the patient has at least one rare symptom and no common or serious symptom, increase P(I) by 20% */
    ((P_CS_S =:= 0, hasRareSymptoms(SYMPTOMS)) -> P_S is 0.2; P_S is P_CS_S), 

    /* if the patient is a high risk patient (elderly or with pre-existing health conditions), increase P(I) by 8% */    
    (highRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS) -> P_R is 0.08; P_R is P_0),
    
    /* if the patient belongs to one of the two previous groups and is a male, increase P(I) by 2% */
    (slightlyHigherRiskPatient(AGE, EXISTING_HEALTH_CONDITIONS, SEX) -> P_HR is P_R + 0.02; P_HR is P_R),
    
    /* if the patient has met someone infected in the past few days, increase P(I) by 40% */
    (metSomeoneInfected(CONTACT) -> P_C is 0.4; P_C is P_0),
    
    /* calculates the probability of being infected */
    (P_I is P_S + P_HR + P_C),

    /* print the diagnose output based on P(I) value */
    ((P_I >= 0.0, P_I < 0.4) -> write('You are not infected: ');
    (P_I >= 0.4, P_I < 0.6) -> write('There is a probability that you are infected, you should take care: ');
    (P_I >= 0.6 -> write('You are infected: '))),
    write(P_I),

    /* print other messages based on patient information */
    /* if the patient has symptoms and has been identified as a high-risk patient, then print the message */
    ((P_HR > 0.0, P_S > 0.0) -> write('\nYou are a high-risk patient, call immediately the doctor.');
    /* if the patient has no symptoms but has been in contact with someone infected, then print the message */
    ((P_S =:= 0.0, P_C > 0.0) -> write('\nYou have no symptoms yet.'))),
    !.
