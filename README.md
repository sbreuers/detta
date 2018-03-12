# DetTA: Detection-Tracking-Analysis

![Overview of the detection-tracking-analysis pipeline](images/pipeline.png?raw=true "Overview of the detection-tracking-analysis pipeline")

Code repository for the under review IROS submission

"Detection-Tracking for Efficient Person Analysis: The DetTA Pipeline"

Stefan Breuers, Lucas Beyer, Umer Rafi and Bastian Leibe
(RWTH Aachen University, Visual Computing Institute)

## Abstract
In the past decade many robots were deployed in the wild, and people detection and tracking is an important component of such deployments.
On top of that, one often needs to run modules which analyze persons and extract higher level attributes such as age and gender, or dynamic information like gaze and pose.
The latter ones are especially necessary for building a reactive, social robot-person interaction.

In this paper, we combine those components in a fully modular detection-tracking-analysis pipeline, called DetTA.
We investigate the benefits of such an integration on the example of head and skeleton pose, by using the consistent track ID for a temporal filtering of the analysis modules' observations, showing a slight improvement in a challenging real-world scenario.
We also study the potential of a so-called "free-flight" mode, where the analysis of a person attribute only relies on the filter's predictions for certain frames.
Here, our study shows that this boosts the runtime dramatically, while the prediction quality remains stable.
This insight is especially important for reducing power consumption and sharing precious (GPU-)memory when running many analysis components on a mobile platform, especially so in the era of expensive deep learning methods.


## Detection-Tracking
Please refer to https://github.com/spencer-project/spencer_people_tracking for the detection-tracking pipeline.

## Analysis
### Head orientation
Biternion nets by L. Beyer et al.

### Skeleton pose
HumanPose by U. Rafi et al.

## Temporal Filtering
Allows for temporal smoothing and free-flight option.
