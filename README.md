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
### General
Allows for temporal smoothing and free-flight option.

### Usage

### Free-flight mode

## Additional Files
### Skeleton Annotation Tool
![The skeleton annotation tool](images/annotool_ex.png?raw=true "The skeleton annotation tool")

In case you face your own annotation task regarding skeleton poses, we provide our MATLAB tool.
The `skeleton_annotation_tool.m` let you annotate joints, the `skeleton_viewer.m` helps in visualizing already annotated persons.

**Usage**: The tool goes through the images in the provided folder (adapt `main_path` and `seq_path` regarding your purpose). It expects images (`img_path`, default: *{main_path}/{seq_path}/img/img_%08d.jpg*) and an annotation file (`anno_path`, default: *{main_path}/{seq_path}/annotations.txt* in the MOTChallenge format (https://motchallenge.net/instructions/).

The tool then lets you annotate the joints via left mouse click in the following order: head, neck, left shoulder/elbow/wrist, right shoulder/elbow/wrist (`joint_names`) and saves everything in a subfolder structure (`save_folder`, `save_path`, `save_path_occ`).
To minimize annotation effort, one can adapt a step size (`anno_step`), frames inbetween are interpolated. We suggest not to choose a value to high depending on the sequence due to annotation noise.

Buttons:
- left-click to annotate the current joint (red color)
- right-click to set the current joint to "occluded" (blue color)
- "s" to skip this frame (set all joints to occluded)
- "r" to redo the last annotated joint (unfortunately does not work across frames, so be careful with the last joint)
- "c" to redo all joints in this frame

The tool can be closed at any time and it will restart after the last fully annotated frame of one person.

Parts of the code can be adapted to serve any "point annotation"-task. Just take care of the `joint_names` variable and the annotation loop regarding frames and ids.
