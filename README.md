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

## Clone the Repository
Please regard that the repository consist of several submodules, which need to be initialized after cloning:
1) git clone https://github.com/sbreuers/detta.git
2) (cd to repo)
3) git submodule update --init

## Detection-Tracking
Please refer to https://github.com/spencer-project/spencer_people_tracking for the detection-tracking pipeline.

Here, we utilized the vision-based MDL tracker by Jafari et al. [1]:
Basically bi-directional Kalman Filters to build an overcomplete set of hypotheses. An individual track score based on appearance motion and detector confidence as well as interaction scores between tracks based on physical overlap and shared detections are computed. A solution is found with quadratic pseudo boolean optimization by a multi-branch method.

## Analysis
### Head orientation
Biternion nets by Beyer et al. [2]:
We predict head orientation using BiternionNets, for which code is publicly available.
Training data is collected at an airport by having volunteers turn in circles in front of our robot, the annotation is straightforward and done in just a few hours.
Biternions have the advantage of providing continuous head pose estimates, which are better suited for filtering than classes, even when trained on discrete labels.
The network architecture is exactly the very lightweight one introduced in [2], but we further perform background-subtraction using the depth data provided by the camera.

### Skeleton pose
HumanPose by Rafi et al. [3]:
For skeleton poses, we use the HumanPose estimation framework.
The framework is an adaptation of GoogleNet, using only the first 17 layers from the network architecture.
The fully connected layer and the average pooling layer in the last stages of the network are removed to make the framework fully convolutional.
A pose decoder consisting of a transposed convolution and a sigmoid layer is appended to the framework to up-sample the low resolution features from the 17th layer to high resolution heat maps for different body joints.
The HumanPose estimation framework was trained on the [MPI dataset](http://human-pose.mpi-inf.mpg.de/) and is also able to also detect occluded joints.

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

## References
[1] Jafari O. H. and Mitzel D. and Leibe B.. *Real-Time RGB-D based People Detection and Tracking for Mobile Robots and Head-Worn Cameras*. IEEE International Conference on Robotics and Automation (ICRA), 2014.
[2] Beyer L. and Hermans A. and Leibe B.. *Biternion nets: Continuous head pose regression from discrete training labels.* German Conference on Pattern Recognition (GCPR), 2015.
[3] Rafi U. and Leibe B. and Gall J.. *An Efficient Convolutional Network for Human Pose Estimation.* British Machine Vision Conference (BMVC), 2016.
