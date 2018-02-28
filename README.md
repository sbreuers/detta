# DetTA: Detection-Tracking-Analysis Pipeline for Temporal Robust Person Attributes

Code repository for the under review IROS submission

"DetTA: Detection-Tracking-Analysis Pipeline for Temporal Robust Person Attributes"

Stefan Breuers, Lucas Beyer, Umer Rafi and Bastian Leibe
(RWTH Aachen University, Visual Computing Institute)

## Abstract
In the last decade robots were taken into the wild and since day one people detection and tracking is an mandatory component.
Building on top of that, it is of high research interest to further analyze present persons to extract attributes, such as age, gender or dynamic information, like gaze direction or pose.
All these are especially useful regarding an appropriate and reactive social robot-person interaction.

In this paper we want to combine those components in a fully modular detection-tracking-analysis pipeline, called DetTA.
We investigate the combinational benefits on the example of head and skeleton pose, by using the consistent track ID for a temporal filtering of the observations from the analysis modules, showing a slight improvement in a challenging real-world scenario. TODO: TRUE?
We also study the potential of a so-called "free-flight" mode, where the analysis of a person attribute only relies on the filter's predictions for certain frames.
Here, our experiments show that this helps boosting the runtime performance significatly, while the quality of the observations hardly drops. TODO: TRUE?
This also holds the potential to reduce power consumption and share the usage of \mbox{(GPU-)memory} on a mobile platform, when running many analysis components, which is especially useful in the era of expensive deep learning methods.


## Detection-Tracking
Please refer to https://github.com/spencer-project/spencer_people_tracking for the detection-tracking pipeline.

## Analysis
### Head orientation
Biternion nets by L. Beyer et al.

### Skeleton pose
HumanPose by U. Rafi et al.

## Temporal Filtering
Allows for temporal smoothing and free-flight option.
