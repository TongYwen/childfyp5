-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 10, 2025 at 03:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `child_growth_insights`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_scores`
--

CREATE TABLE `academic_scores` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `score` int(11) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `academic_scores`
--

INSERT INTO `academic_scores` (`id`, `child_id`, `subject`, `score`, `date`) VALUES
(11, 10, 'english', 85, '2022-04-01'),
(12, 10, 'math', 90, '2020-09-01'),
(13, 10, 'math', 50, '2025-05-01'),
(22, 13, 'Coloring', 80, '2025-03-01'),
(23, 13, 'drawing', 90, '2025-01-01'),
(28, 12, 'English', 65, '2025-03-01'),
(29, 12, 'English', 45, '2025-06-01'),
(30, 12, 'English', 80, '2025-09-01'),
(31, 12, 'Chinese', 80, '2025-03-01'),
(32, 12, 'Chinese', 85, '2025-06-01'),
(33, 12, 'Chinese', 90, '2025-09-01'),
(34, 12, 'Malay', 40, '2025-03-01'),
(35, 12, 'Malay', 50, '2025-06-01'),
(36, 12, 'Malay', 45, '2025-09-01'),
(37, 12, 'Mathematics', 95, '2025-03-01'),
(38, 12, 'Mathematics', 90, '2025-06-01'),
(39, 12, 'Mathematics', 99, '2025-09-01'),
(40, 12, 'Science', 80, '2025-03-01'),
(41, 12, 'Science', 90, '2025-06-01'),
(42, 12, 'Science', 100, '2025-09-01'),
(43, 12, 'English', 30, '2025-12-01'),
(44, 15, 'English', 0, '2025-01-01'),
(45, 15, 'English', 5, '2025-03-01'),
(46, 15, 'English', 60, '2025-06-01'),
(47, 15, 'Chinese', 60, '2025-01-01'),
(48, 15, 'Chinese', 70, '2025-03-01'),
(49, 15, 'Chinese', 69, '2025-06-01'),
(50, 15, 'Malay', 100, '2025-01-01'),
(51, 15, 'Malay', 100, '2025-03-01'),
(52, 15, 'Malay', 100, '2025-06-01'),
(53, 15, 'Mathematics', 6, '2025-01-01'),
(54, 15, 'Mathematics', 25, '2025-03-01'),
(55, 15, 'Mathematics', 100, '2025-06-01'),
(56, 15, 'Science', 67, '2025-01-01'),
(57, 15, 'Science', 40, '2025-03-01'),
(58, 15, 'Science', 99, '2025-06-01');

-- --------------------------------------------------------

--
-- Table structure for table `ai_results`
--

CREATE TABLE `ai_results` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `module` varchar(50) NOT NULL,
  `data` text DEFAULT NULL,
  `result` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ai_results`
--

INSERT INTO `ai_results` (`id`, `child_id`, `module`, `data`, `result`, `created_at`, `updated_at`) VALUES
(1, 10, 'preschool', '[{\"id\": 10, \"child_id\": 10, \"domain\": \"Cognitive Milestones\", \"description\": \"observation\", \"date\": \"2025-11-01\", \"date_str\": \"2025-11\", \"age_months\": 34}, {\"id\": 11, \"child_id\": 10, \"domain\": \"Cognitive Milestones\", \"description\": \"observation\", \"date\": \"2025-11-01\", \"date_str\": \"2025-11\", \"age_months\": 34}, {\"id\": 12, \"child_id\": 10, \"domain\": \"Cognitive Milestones\", \"description\": \"observation\", \"date\": \"2025-11-01\", \"date_str\": \"2025-11\", \"age_months\": 34}, {\"id\": 4, \"child_id\": 10, \"domain\": \"Social/Emotional Milestones\", \"description\": \"ASSESSMENT\", \"date\": \"2025-10-01\", \"date_str\": \"2025-10\", \"age_months\": 33}]', 'The child, mee, born on 2023-01-02, is approximately 34 months (2 years, 10 months) old at the time of the last recorded milestone.\n\n<p><h3>Age-appropriate Areas:</h3></p>\n<p>The recorded milestones, \"Cognitive Milestones: observation (at 34 months)\" and \"Social/Emotional Milestones: ASSESSMENT (at 33 months),\" are too broad and general to allow for a specific comparison to the detailed, observable benchmarks provided. If \"observation\" indicates a general capacity for cognitive engagement and \"ASSESSMENT\" implies a satisfactory review of social-emotional skills, then these broad domains might be considered age-appropriate. However, without specific examples of what \'observation\' entails or the outcomes of the \'ASSESSMENT,\' it is difficult to confirm age-appropriateness against the granular standard milestones for a 34-month-old child, who is expected to be developing skills such as showing simple problem-solving, pretending with objects, following two-step instructions, and engaging in conversations.</p>\n\n<p><h3>Delayed Areas:</h3></p>\n<p>Given the highly generalized nature of the child\'s recorded milestones, it is not possible to identify specific areas of delay. If \'observation\' were to refer to very basic visual tracking or attention, this would be significantly delayed as such skills are typically achieved in early infancy (e.g., \'Looks at your face\' at 2 months). However, it is more likely that \'observation\' is intended as a general statement of cognitive function rather than a specific, new skill.</p>\n\n<p><h3>Advanced Areas:</h3></p>\n<p>Due to the lack of specific detail in the recorded milestones, no advanced developmental areas can be definitively identified. The general terms \'observation\' and \'ASSESSMENT\' do not provide sufficient information to determine if mee is exceeding typical developmental expectations in any domain.</p>\n\n<p>Overall, the child\'s recorded milestones are too vague to provide a detailed comparison with standard age-based benchmarks, limiting the ability to precisely assess specific areas of development.</p>', '2025-10-09 15:22:44', '2025-10-13 15:55:13'),
(2, 10, 'learning', '{\n  \"observations\": [\n    {\n      \"id\": 4,\n      \"child_id\": 10,\n      \"observation\": \"ABC\",\n      \"created_at\": \"2025-10-09 23:25:04\"\n    }\n  ],\n  \"answers\": []\n}', '<p><strong>Most Likely Learning Style:</strong> Mixed (Visual, Auditory, and Kinesthetic)</p>\n\n<h3>Reasoning:</h3>\n<p>\n    Given the very limited observation of \"ABC\" and the absence of specific test responses, it is most probable that this preschooler demonstrates a Mixed learning style, engaging multiple senses. In early childhood, foundational knowledge like the alphabet is typically acquired through a combination of visual input (seeing letters in books or on charts), auditory engagement (singing alphabet songs or hearing letter sounds), and kinesthetic activities (tracing letters, manipulating alphabet blocks, or using actions for letter recognition). Without more detailed behavioral observations or specific indicators of preference, a multi-modal approach is generally the most effective and common learning pathway for young children to absorb and process new information.\n</p>\n\n<h3>Actionable Suggestions for Parents/Teachers:</h3>\n<ul>\n    <li><strong>Utilize Multi-Sensory Activities:</strong> Integrate sight, sound, and touch into learning. For example, use colorful alphabet flashcards (visual), sing the ABC song (auditory), and encourage tracing letters in sand or with play-doh (kinesthetic).</li>\n    <li><strong>Observe and Adapt:</strong> Pay close attention to which activities the child seems most engaged with or responds to best. This ongoing observation can help identify emerging preferences and allow for further customization of learning experiences.</li>\n    <li><strong>Incorporate Hands-On Exploration:</strong> Provide plenty of opportunities for active, discovery-based learning. Building with letter blocks, playing alphabet puzzles, and engaging in movement-based games are excellent ways to reinforce concepts.</li>\n    <li><strong>Read Aloud and Use Rhymes:</strong> Regularly read picture books, point out letters and words, and recite nursery rhymes or songs. This strengthens both visual and auditory processing skills, fostering early literacy development.</li>\n    <li><strong>Create a Varied Learning Environment:</strong> Offer a mix of structured and free-play activities, both indoors and outdoors, to cater to different energy levels and provide diverse opportunities for learning and exploration.</li>\n</ul>', '2025-10-09 15:25:31', '2025-10-09 15:25:31'),
(3, 10, 'tutoring', '{\n  \"learning\": \"<p><strong>Most Likely Learning Style:</strong> Mixed (Visual, Auditory, and Kinesthetic)</p>\\n\\n<h3>Reasoning:</h3>\\n<p>\\n    Given the very limited observation of \\\"ABC\\\" and the absence of specific test responses, it is most probable that this preschooler demonstrates a Mixed learning style, engaging multiple senses. In early childhood, foundational knowledge like the alphabet is typically acquired through a combination of visual input (seeing letters in books or on charts), auditory engagement (singing alphabet songs or hearing letter sounds), and kinesthetic activities (tracing letters, manipulating alphabet blocks, or using actions for letter recognition). Without more detailed behavioral observations or specific indicators of preference, a multi-modal approach is generally the most effective and common learning pathway for young children to absorb and process new information.\\n</p>\\n\\n<h3>Actionable Suggestions for Parents/Teachers:</h3>\\n<ul>\\n    <li><strong>Utilize Multi-Sensory Activities:</strong> Integrate sight, sound, and touch into learning. For example, use colorful alphabet flashcards (visual), sing the ABC song (auditory), and encourage tracing letters in sand or with play-doh (kinesthetic).</li>\\n    <li><strong>Observe and Adapt:</strong> Pay close attention to which activities the child seems most engaged with or responds to best. This ongoing observation can help identify emerging preferences and allow for further customization of learning experiences.</li>\\n    <li><strong>Incorporate Hands-On Exploration:</strong> Provide plenty of opportunities for active, discovery-based learning. Building with letter blocks, playing alphabet puzzles, and engaging in movement-based games are excellent ways to reinforce concepts.</li>\\n    <li><strong>Read Aloud and Use Rhymes:</strong> Regularly read picture books, point out letters and words, and recite nursery rhymes or songs. This strengthens both visual and auditory processing skills, fostering early literacy development.</li>\\n    <li><strong>Create a Varied Learning Environment:</strong> Offer a mix of structured and free-play activities, both indoors and outdoors, to cater to different energy levels and provide diverse opportunities for learning and exploration.</li>\\n</ul>\",\n  \"preschool\": \"The child, mee, born on 2023-01-02, is approximately 34 months (2 years, 10 months) old at the time of the last recorded milestone.\\n\\n<p><h3>Age-appropriate Areas:</h3></p>\\n<p>The recorded milestones, \\\"Cognitive Milestones: observation (at 34 months)\\\" and \\\"Social/Emotional Milestones: ASSESSMENT (at 33 months),\\\" are too broad and general to allow for a specific comparison to the detailed, observable benchmarks provided. If \\\"observation\\\" indicates a general capacity for cognitive engagement and \\\"ASSESSMENT\\\" implies a satisfactory review of social-emotional skills, then these broad domains might be considered age-appropriate. However, without specific examples of what \'observation\' entails or the outcomes of the \'ASSESSMENT,\' it is difficult to confirm age-appropriateness against the granular standard milestones for a 34-month-old child, who is expected to be developing skills such as showing simple problem-solving, pretending with objects, following two-step instructions, and engaging in conversations.</p>\\n\\n<p><h3>Delayed Areas:</h3></p>\\n<p>Given the highly generalized nature of the child\'s recorded milestones, it is not possible to identify specific areas of delay. If \'observation\' were to refer to very basic visual tracking or attention, this would be significantly delayed as such skills are typically achieved in early infancy (e.g., \'Looks at your face\' at 2 months). However, it is more likely that \'observation\' is intended as a general statement of cognitive function rather than a specific, new skill.</p>\\n\\n<p><h3>Advanced Areas:</h3></p>\\n<p>Due to the lack of specific detail in the recorded milestones, no advanced developmental areas can be definitively identified. The general terms \'observation\' and \'ASSESSMENT\' do not provide sufficient information to determine if mee is exceeding typical developmental expectations in any domain.</p>\\n\\n<p>Overall, the child\'s recorded milestones are too vague to provide a detailed comparison with standard age-based benchmarks, limiting the ability to precisely assess specific areas of development.</p>\"\n}', '<h3>1. Potential Weak Areas or Skills that May Need Support:</h3>\n<ul>\n    <li>**Lack of Specific Developmental Data:** The most significant area needing support is the absence of detailed, observable milestones across all key developmental domains (Cognitive, Language, Fine Motor, Gross Motor, Social-Emotional). Without this specific information, it is impossible to accurately identify Mee\'s unique strengths or precise areas requiring targeted support relative to age-appropriate benchmarks for a 34-month-old.</li>\n    <li>**Undefined Cognitive Skills:** While \"observation\" is noted, specific cognitive abilities expected at 34 months, such as simple problem-solving, understanding of basic concepts (e.g., shapes, colors, numbers), memory, and engaging in pretend play, are not documented. These areas may require support if not adequately developed.</li>\n    <li>**Undefined Language and Communication Skills:** There is no recorded information regarding Mee\'s expressive or receptive language, vocabulary size, ability to follow two-step instructions, or engagement in back-and-forth conversations. These are critical developmental markers at this age and represent potential areas of needed focus.</li>\n    <li>**Undefined Fine and Gross Motor Skills:** Essential physical development areas like manipulating small objects, pre-writing skills, drawing, running, jumping, and balancing are not mentioned, leaving these domains unassessed and potentially in need of targeted activities.</li>\n    <li>**Undefined Social-Emotional Specifics:** While an \"ASSESSMENT\" was completed, the specifics of Mee\'s social interactions (e.g., sharing, turn-taking), emotional regulation, independence in self-care, or imaginative play skills are unknown.</li>\n</ul>\n\n<h3>2. Subjects or Developmental Domains Where Tutoring or Extra Help Would Be Most Beneficial:</h3>\n<ul>\n    <li>**Comprehensive Developmental Assessment:** The most crucial initial \"extra help\" would be a thorough, detailed assessment across all developmental domains (Cognitive, Language, Social-Emotional, Fine Motor, Gross Motor). This would establish a baseline, identify specific strengths, and pinpoint precise areas requiring targeted intervention or support.</li>\n    <li>**Early Literacy and Language Development:** Given the mention of \"ABC\" and the critical importance of language at this age, support in vocabulary expansion, listening comprehension, following instructions, engaging in simple conversations, letter recognition, and pre-reading skills would be highly beneficial.</li>\n    <li>**Foundational Cognitive Skills:** Tutoring could focus on problem-solving through puzzles and games, sorting and matching activities, understanding basic concepts (colors, shapes, numbers), and developing memory skills through engaging play.</li>\n    <li>**Social-Emotional Skill Building:** Opportunities for structured and unstructured social play to develop skills such as sharing, turn-taking, empathy, and appropriate emotional expression.</li>\n    <li>**Fine and Gross Motor Coordination:** Activities designed to enhance hand-eye coordination (e.g., stacking, threading), pre-writing skills (e.g., tracing, scribbling), balance, and overall physical agility through active play.</li>\n</ul>\n\n<h3>3. Personalized Activity or Tutoring Style Recommendations Aligned with the Learning Style:</h3>\n<ul>\n    <li>**Multi-Sensory Play-Based Learning:** Since Mee exhibits a Mixed (Visual, Auditory, Kinesthetic) learning style, all learning should be embedded in play and actively engage multiple senses simultaneously. For example, when learning about animals, use picture cards (visual), make animal sounds (auditory), and pretend to be the animals (kinesthetic).</li>\n    <li>**Hands-On Exploration and Discovery:** Provide abundant opportunities for Mee to manipulate objects, build, trace, and engage in active, discovery-based learning. Examples include using alphabet blocks, play-doh for letter formation, sensory bins, science experiments for toddlers, and movement-based games to learn concepts.</li>\n    <li>**Visual Reinforcement:** Utilize colorful picture books, flashcards, charts, and visual schedules to aid understanding and memory. Point to letters, words, and objects while talking about them to connect visual cues with auditory information. Demonstrations are also highly effective.</li>\n    <li>**Auditory Engagement through Storytelling and Music:** Incorporate reading aloud daily, singing songs (especially alphabet, number, and concept-based songs), reciting rhymes, and engaging in verbal storytelling. Encourage Mee to repeat words, phrases, and sounds to build vocabulary and listening skills.</li>\n    <li>**Interactive and Conversational Approach:** Foster active participation by asking open-ended questions (\"What do you think will happen next?\"), responding to Mee\'s queries with enthusiasm, and creating a dialogue-rich environment to develop language and critical thinking.</li>\n    <li>**Varied Activities and Environments:** Offer a diverse range of activities, alternating between quiet indoor tasks (e.g., drawing, puzzles) and active outdoor play (e.g., running, climbing), and switching between structured learning and free exploration to maintain engagement and cater to different aspects of the mixed learning style.</li>\n</ul>\n\nFor parents and teachers, the immediate priority is to conduct a detailed and specific assessment of Mee\'s development across all key domains. This comprehensive understanding will allow for the implementation of highly personalized, multi-sensory, and play-based learning experiences that leverage Mee\'s mixed learning style to support optimal growth in language, cognitive, social, and motor skills.', '2025-10-09 15:26:30', '2025-10-16 15:22:35'),
(11, 11, 'learning', '{\n  \"observations\": [\n    {\n      \"id\": 8,\n      \"child_id\": 11,\n      \"observation\": \"hand on activities\",\n      \"created_at\": \"2025-10-17 14:23:48\"\n    }\n  ],\n  \"answers\": [\n    {\n      \"answer_id\": 7,\n      \"test_id\": 4,\n      \"question_id\": 22,\n      \"answer\": \"2\",\n      \"created_at\": \"2025-10-16 23:29:52\",\n      \"test_name\": \"abc\",\n      \"question_text\": \"1+1\"\n    },\n    {\n      \"answer_id\": 8,\n      \"test_id\": 4,\n      \"question_id\": 23,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-10-16 23:29:52\",\n      \"test_name\": \"abc\",\n      \"question_text\": \"2+2\"\n    },\n    {\n      \"answer_id\": 9,\n      \"test_id\": 4,\n      \"question_id\": 24,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-10-16 23:29:52\",\n      \"test_name\": \"abc\",\n      \"question_text\": \"3+2\"\n    }\n  ]\n}', '<div style=\"font-family: Arial, sans-serif; line-height: 1.6;\">\n\n    <h2 style=\"color: #2c3e50;\">Learning Style Assessment</h2>\n\n    <p style=\"font-size: 1.1em;\">\n        Based on the observations and test responses, this child\'s most likely learning style is <strong style=\"color: #27ae60;\">Kinesthetic</strong>.\n    </p>\n\n    <h3 style=\"color: #2c3e50;\">Reasoning:</h3>\n    <p>\n        The key observation, \"hand on activities,\" strongly suggests that this child learns best by doing, touching, and experiencing. Kinesthetic learners thrive when they can actively engage with materials and concepts through movement and physical manipulation. They often understand and remember information more effectively when it\'s connected to a tangible experience rather than just seeing or hearing it. This active, exploratory approach is crucial for their cognitive development and engagement in learning tasks.\n    </p>\n\n    <h3 style=\"color: #2c3e50;\">Actionable Suggestions for Parents and Teachers:</h3>\n    <ul style=\"list-style-type: disc; margin-left: 20px;\">\n        <li style=\"margin-bottom: 8px;\">\n            <strong style=\"color: #3498db;\">Incorporate Movement:</strong> Use physical games like jumping to numbers, acting out stories, or building with blocks to teach new concepts.\n        </li>\n        <li style=\"margin-bottom: 8px;\">\n            <strong style=\"color: #3498db;\">Provide Manipulatives:</strong> Offer a variety of hands-on tools such as counters, puzzles, play-dough, or sensory bins for exploring math, letters, and scientific ideas.\n        </li>\n        <li style=\"margin-bottom: 8px;\">\n            <strong style=\"color: #3498db;\">Encourage Practical Exploration:</strong> Involve the child in real-world tasks like helping with cooking (measuring ingredients), gardening (planting seeds), or sorting laundry to make learning relevant and tactile.\n        </li>\n        <li style=\"margin-bottom: 8px;\">\n            <strong style=\"color: #3498db;\">Create Learning Stations:</strong> Design activity zones where they can build, experiment, and engage with different textures and materials, allowing them to discover at their own pace.\n        </li>\n    </ul>\n\n</div>', '2025-10-16 15:30:22', '2025-10-17 06:25:00'),
(12, 11, 'tutoring', '{\n  \"learning\": \"<div style=\\\"font-family: Arial, sans-serif; line-height: 1.6;\\\">\\n\\n    <h2 style=\\\"color: #2c3e50;\\\">Learning Style Assessment</h2>\\n\\n    <p style=\\\"font-size: 1.1em;\\\">\\n        Based on the observations and test responses, this child\'s most likely learning style is <strong style=\\\"color: #27ae60;\\\">Kinesthetic</strong>.\\n    </p>\\n\\n    <h3 style=\\\"color: #2c3e50;\\\">Reasoning:</h3>\\n    <p>\\n        The key observation, \\\"hand on activities,\\\" strongly suggests that this child learns best by doing, touching, and experiencing. Kinesthetic learners thrive when they can actively engage with materials and concepts through movement and physical manipulation. They often understand and remember information more effectively when it\'s connected to a tangible experience rather than just seeing or hearing it. This active, exploratory approach is crucial for their cognitive development and engagement in learning tasks.\\n    </p>\\n\\n    <h3 style=\\\"color: #2c3e50;\\\">Actionable Suggestions for Parents and Teachers:</h3>\\n    <ul style=\\\"list-style-type: disc; margin-left: 20px;\\\">\\n        <li style=\\\"margin-bottom: 8px;\\\">\\n            <strong style=\\\"color: #3498db;\\\">Incorporate Movement:</strong> Use physical games like jumping to numbers, acting out stories, or building with blocks to teach new concepts.\\n        </li>\\n        <li style=\\\"margin-bottom: 8px;\\\">\\n            <strong style=\\\"color: #3498db;\\\">Provide Manipulatives:</strong> Offer a variety of hands-on tools such as counters, puzzles, play-dough, or sensory bins for exploring math, letters, and scientific ideas.\\n        </li>\\n        <li style=\\\"margin-bottom: 8px;\\\">\\n            <strong style=\\\"color: #3498db;\\\">Encourage Practical Exploration:</strong> Involve the child in real-world tasks like helping with cooking (measuring ingredients), gardening (planting seeds), or sorting laundry to make learning relevant and tactile.\\n        </li>\\n        <li style=\\\"margin-bottom: 8px;\\\">\\n            <strong style=\\\"color: #3498db;\\\">Create Learning Stations:</strong> Design activity zones where they can build, experiment, and engage with different textures and materials, allowing them to discover at their own pace.\\n        </li>\\n    </ul>\\n\\n</div>\",\n  \"preschool\": null\n}', '<div style=\"font-family: Arial, sans-serif; line-height: 1.6;\">\n\n    <h2 style=\"color: #2c3e50;\">Tutoring and Support Recommendations for a Kinesthetic Learner</h2>\n\n    <p style=\"font-size: 1.1em;\">\n        Based on the provided learning style analysis, which identifies the child as a primary kinesthetic learner, the following recommendations are tailored to support their unique developmental needs. Kinesthetic learners thrive through movement, touch, and hands-on interaction, meaning their educational experiences should be rich with physical engagement.\n    </p>\n\n    <h3 style=\"color: #2c3e50;\">1. Potential Weak Areas or Skills That May Need Support:</h3>\n    <ul>\n        <li><strong>Abstract Concepts:</strong> Without concrete, hands-on examples, this child may struggle to grasp abstract ideas in subjects like early math (e.g., addition without counters) or language arts (e.g., understanding a story purely through listening).</li>\n        <li><strong>Sustained Passive Learning:</strong> Activities requiring long periods of sitting still, listening, or simply observing (e.g., extended story times without interactive elements, flashcard drills without physical manipulation) may lead to disengagement, difficulty focusing, or appearing restless.</li>\n        <li><strong>Rote Memorization:</strong> Learning facts, letters, or numbers without a physical or experiential connection (e.g., tracing letters, building number towers) might be less effective and require more effort than for other learning styles.</li>\n        <li><strong>Fine Motor Skill Development (if not actively engaged):</strong> While kinesthetic learners often enjoy fine motor activities, if the learning environment doesn\'t offer ample opportunities for manipulation (e.g., puzzles, play-dough, cutting, drawing), these skills might not be fully developed in a way that aligns with their learning style.</li>\n    </ul>\n\n    <h3 style=\"color: #2c3e50;\">2. Subjects or Developmental Domains Where Tutoring or Extra Help Would Be Most Beneficial:</h3>\n    <ul>\n        <li><strong>Early Literacy (Letters, Sounds, Story Comprehension):</strong> Tutoring could focus on tracing letters in sand, building letters with blocks, acting out story characters, or using magnetic letters to form words, making reading and writing foundational skills tangible.</li>\n        <li><strong>Early Numeracy (Counting, Number Recognition, Basic Math Concepts):</strong> Extra support using counters, building blocks for addition/subtraction, sorting objects by attributes, or physical games that involve counting and measuring would be highly effective.</li>\n        <li><strong>Science and Exploration:</strong> Hands-on experiments, nature walks with active collection and observation, and building simple machines or models would deepen understanding.</li>\n        <li><strong>Problem-Solving and Critical Thinking:</strong> Tutoring through puzzles, construction tasks, and experimental play allows the child to physically manipulate elements to discover solutions.</li>\n    </ul>\n\n    <h3 style=\"color: #2c3e50;\">3. Personalized Activity or Tutoring Style Recommendations:</h3>\n    <ul>\n        <li><strong>Active Learning Sessions:</strong> Tutoring should incorporate frequent movement breaks and integrate physical activity directly into lessons. For example, jumping jacks for each correct answer, or moving around to find \"hidden\" sight words.</li>\n        <li><strong>Manipulatives are Key:</strong> Always have a variety of hands-on tools available. This includes blocks, counters, sensory bins (rice, beans, water beads) for letter/number recognition, play-dough for letter formation, and tangrams for spatial reasoning.</li>\n        <li><strong>Experiential and Practical Tasks:</strong> Frame learning within real-world scenarios. For example, use cooking to teach measurement, gardening to understand plant cycles, or sorting laundry to practice classification and counting.</li>\n        <li><strong>Building and Constructing:</strong> Incorporate building tasks related to concepts. If learning about shapes, build structures using those shapes. If learning about animals, build animal enclosures.</li>\n        <li><strong>Role-Playing and Acting Out:</strong> For stories or social-emotional learning, encourage the child to act out scenarios or become characters. This helps them embody the learning.</li>\n        <li><strong>Sensory Engagement:</strong> Utilize multiple senses. Beyond touch, consider textures, smells, and even tastes (safely) when appropriate to create a multi-sensory learning experience.</li>\n    </ul>\n\n    <p style=\"font-size: 1.1em;\">\n        For parents and teachers, understanding this child\'s kinesthetic learning style is crucial for fostering engagement and effective learning. By prioritizing movement, hands-on activities, and practical exploration across all subjects, you can create an enriching environment where this child feels understood, thrives, and builds a strong foundation for future academic success. The goal is to make learning an active, physical adventure rather than a passive observation.\n    </p>\n\n</div>', '2025-10-16 15:33:36', '2025-10-17 10:26:21'),
(13, 12, 'preschool', '[{\"id\": 14, \"child_id\": 12, \"domain\": \"Language/Communication\", \"description\": \"test\", \"date\": \"2025-11-01\", \"date_str\": \"2025-11\", \"age_months\": 68}, {\"id\": 15, \"child_id\": 12, \"domain\": \"Movement/Physical Development\", \"description\": \"My child do not know how to walk even she is 5 years old\", \"date\": \"2025-11-01\", \"date_str\": \"2025-11\", \"age_months\": 68}, {\"id\": 16, \"child_id\": 12, \"domain\": \"Social/Emotional Milestones\", \"description\": \"Always not happy\", \"date\": \"2025-11-01\", \"date_str\": \"2025-11\", \"age_months\": 68}]', '<div style=\"font-family: Arial, sans-serif;\">\n    <p><strong>Child\'s Age for Assessment:</strong> 68 months (5 years and 8 months)</p>\n\n    <h3 style=\"color: #4CAF50;\">Areas that are age-appropriate</h3>\n    <ul>\n        <li>No specific milestones were recorded as age-appropriate for Lam Ah Li at 68 months based on the provided data.</li>\n    </ul>\n\n    <h3 style=\"color: #F44336;\">Areas that are delayed</h3>\n    <ul>\n        <li><strong>Movement/Physical Development:</strong> Lam Ah Li does not know how to walk at 68 months (5 years 8 months). Independent walking is typically achieved by 18 months. This represents a severe developmental delay in this area.</li>\n        <li><strong>Social/Emotional Milestones:</strong> Lam Ah Li is recorded as \"Always not happy\" at 68 months. Typical social-emotional development for a child of this age includes expressing a range of emotions, engaging happily with others, and showing empathy. This observation suggests significant concerns regarding emotional well-being and social-emotional development.</li>\n        <li><strong>Language/Communication:</strong> Although a \"test\" was recorded, no specific language achievements (e.g., telling stories, speaking in complex sentences, naming letters) are provided for Lam Ah Li at 68 months. For a child of this age, significant progress in verbal communication is expected. The absence of reported milestones suggests a likely delay in this area.</li>\n    </ul>\n\n    <h3 style=\"color: #2196F3;\">Areas that are advanced for the child\'s age</h3>\n    <ul>\n        <li>No advanced milestones were recorded for Lam Ah Li based on the provided data.</li>\n    </ul>\n\n    <p style=\"font-weight: bold; margin-top: 20px;\">\n        Overall, Lam Ah Li demonstrates significant developmental delays in Movement/Physical Development and Social/Emotional Milestones, with concerns regarding Language/Communication based on the absence of reported age-appropriate achievements.\n    </p>\n</div>', '2025-11-19 04:36:26', '2025-11-19 17:06:45'),
(14, 12, 'tutoring', '{\n  \"learning\": \"<h5>Learning Style Summary</h5>\\n<ul>\\n<li>Visual          : Strong, as they consistently prefer images, videos, and visual materials.</li>\\n<li>Auditory        : Moderate, as they enjoy discussions and sound-based games.</li>\\n<li>Reading/Writing : Moderate, as they show interest in written words and early literacy.</li>\\n<li>Kinesthetic     : Weak, as hands-on activities are not their primary learning preference.</li>\\n</ul>\\n\\n<h5>Main Learning Style</h5>\\n<p>Your child is primarily a visual learner, with developing strengths in auditory and early reading/writing styles.</p>\\n\\n<h6>Tips for Parents</h6>\\n<ul>\\n<li>Use plenty of pictures, videos, and visual aids when teaching new things.</li>\\n<li>Encourage discussions and ask questions to help your child process information.</li>\\n<li>Point out words and labels in books and daily life to nurture early reading skills.</li>\\n</ul>\",\n  \"preschool\": \"<div style=\\\"font-family: Arial, sans-serif;\\\">\\n    <p><strong>Child\'s Age for Assessment:</strong> 68 months (5 years and 8 months)</p>\\n\\n    <h3 style=\\\"color: #4CAF50;\\\">Areas that are age-appropriate</h3>\\n    <ul>\\n        <li>No specific milestones were recorded as age-appropriate for Lam Ah Li at 68 months based on the provided data.</li>\\n    </ul>\\n\\n    <h3 style=\\\"color: #F44336;\\\">Areas that are delayed</h3>\\n    <ul>\\n        <li><strong>Movement/Physical Development:</strong> Lam Ah Li does not know how to walk at 68 months (5 years 8 months). Independent walking is typically achieved by 18 months. This represents a severe developmental delay in this area.</li>\\n        <li><strong>Social/Emotional Milestones:</strong> Lam Ah Li is recorded as \\\"Always not happy\\\" at 68 months. Typical social-emotional development for a child of this age includes expressing a range of emotions, engaging happily with others, and showing empathy. This observation suggests significant concerns regarding emotional well-being and social-emotional development.</li>\\n        <li><strong>Language/Communication:</strong> Although a \\\"test\\\" was recorded, no specific language achievements (e.g., telling stories, speaking in complex sentences, naming letters) are provided for Lam Ah Li at 68 months. For a child of this age, significant progress in verbal communication is expected. The absence of reported milestones suggests a likely delay in this area.</li>\\n    </ul>\\n\\n    <h3 style=\\\"color: #2196F3;\\\">Areas that are advanced for the child\'s age</h3>\\n    <ul>\\n        <li>No advanced milestones were recorded for Lam Ah Li based on the provided data.</li>\\n    </ul>\\n\\n    <p style=\\\"font-weight: bold; margin-top: 20px;\\\">\\n        Overall, Lam Ah Li demonstrates significant developmental delays in Movement/Physical Development and Social/Emotional Milestones, with concerns regarding Language/Communication based on the absence of reported age-appropriate achievements.\\n    </p>\\n</div>\"\n}', '<h3>1. Potential Weak Areas</h3>\n<ul>\n  <li><strong>Gross Motor Skills:</strong> Lam Ah Li shows a severe delay in physical development, specifically not yet knowing how to walk at 5 years 8 months, which is significantly beyond the typical age for independent walking. This indicates a critical need for support in balance, coordination, and fundamental movement.</li>\n  <li><strong>Emotional Regulation and Expression:</strong> The observation that Lam Ah Li is \"Always not happy\" suggests difficulties in managing and expressing a range of emotions in a positive and age-appropriate manner, impacting overall well-being.</li>\n  <li><strong>Social Interaction and Engagement:</strong> Linked to emotional well-being, the lack of reported happy engagement indicates potential challenges in initiating and maintaining social interactions with others.</li>\n  <li><strong>Expressive and Receptive Language Skills:</strong> The absence of specific reported language milestones at 5 years 8 months, despite a \"test,\" strongly suggests a delay in verbal communication, including vocabulary, sentence formation, and comprehension.</li>\n</ul>\n\n<h3>2. Recommended Focus Areas</h3>\n<ul>\n  <li><strong>Physical Therapy and Gross Motor Development:</strong> Intensive support is crucial for developing foundational movement skills, including assisted walking, balance, and strengthening exercises.</li>\n  <li><strong>Social-Emotional Learning:</strong> Activities designed to help Lam Ah Li identify, understand, and express her emotions, as well as fostering positive social interactions and happiness.</li>\n  <li><strong>Language and Communication Development:</strong> Focused efforts on building vocabulary, encouraging verbal expression, improving listening comprehension, and fostering early literacy skills.</li>\n</ul>\n\n<h3>3. Personalized Activities</h3>\n<ul>\n  <li><strong>Interactive Movement Videos & Music:</strong> Given her strong visual preference, play engaging children\'s videos with simple movements, dances, or exercises. Encourage her to watch and, with gentle assistance, mimic even small actions or gestures. Pair this with upbeat music to stimulate auditory senses and create a positive atmosphere.</li>\n  <li><strong>\"Feelings Finder\" with Picture Cards:</strong> Use large, clear picture cards depicting various emotions (happy, sad, angry, surprised). Point to each card, name the emotion, and discuss what makes people feel that way. Encourage Lam Ah Li to point to how she feels or make corresponding facial expressions.</li>\n  <li><strong>Visual Storytelling & Narration:</strong> Read highly visual picture books or watch short animated stories together. Pause frequently to point out objects, characters, and actions, naming them clearly. Narrate what is happening (\"The bird is flying up!\") and encourage her to respond with sounds, gestures, or words, building both language and visual comprehension.</li>\n  <li><strong>\"Show Me\" Vocabulary Games:</strong> Use visual aids like flashcards or real objects. Name an item and ask Lam Ah Li to point to it (\"Show me the ball\"). Conversely, point to an item and ask \"What is this?\" This reinforces receptive and expressive language through visual cues.</li>\n</ul>\n\n<h3>4. Recommended Learning Materials</h3>\n<p>Here are specific products to support Lam Ah Li\'s learning:</p>\n\n\n\n\n\n\n\n\n\n<p><strong>Parent Action Plan:</strong> Your immediate focus should be on consistently supporting Lam Ah Li\'s physical development with assisted movement, alongside creating a nurturing environment for emotional expression and social engagement. Actively integrate visual and auditory learning resources into daily routines to build her language skills and foster overall happiness.</p>', '2025-11-19 04:37:00', '2025-12-01 09:49:43'),
(16, 12, 'insights', '{\"scores\": [{\"subject\": \"English\", \"score\": 65, \"date\": \"2025-03-01\"}, {\"subject\": \"Mathematics\", \"score\": 95, \"date\": \"2025-03-01\"}, {\"subject\": \"Science\", \"score\": 80, \"date\": \"2025-03-01\"}, {\"subject\": \"Chinese\", \"score\": 80, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 40, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 50, \"date\": \"2025-06-01\"}, {\"subject\": \"Science\", \"score\": 90, \"date\": \"2025-06-01\"}, {\"subject\": \"Chinese\", \"score\": 85, \"date\": \"2025-06-01\"}, {\"subject\": \"English\", \"score\": 45, \"date\": \"2025-06-01\"}, {\"subject\": \"Mathematics\", \"score\": 90, \"date\": \"2025-06-01\"}, {\"subject\": \"Science\", \"score\": 100, \"date\": \"2025-09-01\"}, {\"subject\": \"Mathematics\", \"score\": 99, \"date\": \"2025-09-01\"}, {\"subject\": \"Malay\", \"score\": 45, \"date\": \"2025-09-01\"}, {\"subject\": \"Chinese\", \"score\": 90, \"date\": \"2025-09-01\"}, {\"subject\": \"English\", \"score\": 80, \"date\": \"2025-09-01\"}, {\"subject\": \"English\", \"score\": 30, \"date\": \"2025-12-01\"}], \"games\": [{\"id\": 1, \"child_id\": 12, \"game_id\": 1, \"score\": 4, \"total_questions\": 5, \"time_spent_seconds\": 40, \"played_at\": \"2025-11-29 02:08:09\", \"game_title\": \"Counting Animals\", \"game_key\": \"counting_animals\"}, {\"id\": 2, \"child_id\": 12, \"game_id\": 1, \"score\": 5, \"total_questions\": 5, \"time_spent_seconds\": 59, \"played_at\": \"2025-11-29 08:12:05\", \"game_title\": \"Counting Animals\", \"game_key\": \"counting_animals\"}, {\"id\": 3, \"child_id\": 12, \"game_id\": 1, \"score\": 5, \"total_questions\": 5, \"time_spent_seconds\": 59, \"played_at\": \"2025-11-29 08:22:14\", \"game_title\": \"Counting Animals\", \"game_key\": \"counting_animals\"}, {\"id\": 4, \"child_id\": 12, \"game_id\": 2, \"score\": 4, \"total_questions\": 5, \"time_spent_seconds\": 22, \"played_at\": \"2025-11-29 08:49:52\", \"game_title\": \"Animal Vocabulary\", \"game_key\": \"vocab_animals\"}, {\"id\": 5, \"child_id\": 12, \"game_id\": 3, \"score\": 5, \"total_questions\": 5, \"time_spent_seconds\": 19, \"played_at\": \"2025-11-29 09:12:13\", \"game_title\": \"Animal Spelling\", \"game_key\": \"spelling_animals\"}, {\"id\": 6, \"child_id\": 12, \"game_id\": 3, \"score\": 5, \"total_questions\": 5, \"time_spent_seconds\": 15, \"played_at\": \"2025-11-29 09:13:13\", \"game_title\": \"Animal Spelling\", \"game_key\": \"spelling_animals\"}, {\"id\": 7, \"child_id\": 12, \"game_id\": 3, \"score\": 5, \"total_questions\": 5, \"time_spent_seconds\": 16, \"played_at\": \"2025-11-29 09:28:14\", \"game_title\": \"Animal Spelling\", \"game_key\": \"spelling_animals\"}, {\"id\": 8, \"child_id\": 12, \"game_id\": 2, \"score\": 5, \"total_questions\": 5, \"time_spent_seconds\": 14, \"played_at\": \"2025-11-29 09:28:33\", \"game_title\": \"Animal Vocabulary\", \"game_key\": \"vocab_animals\"}, {\"id\": 9, \"child_id\": 12, \"game_id\": 1, \"score\": 4, \"total_questions\": 5, \"time_spent_seconds\": 20, \"played_at\": \"2025-11-29 09:28:57\", \"game_title\": \"Counting Animals\", \"game_key\": \"counting_animals\"}, {\"id\": 10, \"child_id\": 12, \"game_id\": 3, \"score\": 3, \"total_questions\": 5, \"time_spent_seconds\": 22, \"played_at\": \"2025-11-29 12:06:09\", \"game_title\": \"Animal Spelling\", \"game_key\": \"spelling_animals\"}, {\"id\": 11, \"child_id\": 12, \"game_id\": 3, \"score\": 3, \"total_questions\": 5, \"time_spent_seconds\": 25, \"played_at\": \"2025-12-04 20:06:59\", \"game_title\": \"Animal Spelling\", \"game_key\": \"spelling_animals\"}]}', '<div class=\"ai-report-cards\">\n\n  <div class=\"ai-card ai-card-snapshot\">\n    <h3>Learning Personality Summary</h3>\n    <ul>\n      <li><strong>Thinking style:</strong> Systematic and analytical.</li>\n      <li><strong>Motivation patterns:</strong> Driven by understanding clear rules and achieving mastery in structured tasks.</li>\n      <li><strong>Supportive environment:</strong> Structured activities, visual aids, and opportunities to apply logical thinking.</li>\n    </ul>\n  </div>\n\n  <div class=\"ai-card ai-card-strengths\">\n    <h3>Learning Strengths</h3>\n    <ul>\n      <li>Lam Ah Li shows a strong ability to grasp rules quickly and identify patterns, especially in structured tasks. She demonstrates persistence in areas where she feels confident, improving with practice and retaining concepts effectively.</li>\n    </ul>\n  </div>\n\n  <div class=\"ai-card ai-card-areas\">\n    <h3>Challenges & Frustration Triggers</h3>\n    <ul>\n      <li>She may lose focus or feel overwhelmed by tasks that lack clear structure or become significantly more challenging without a sense of immediate progress. Sustaining engagement in these areas might require additional encouragement.</li>\n    </ul>\n  </div>\n\n  <div class=\"ai-card ai-card-style\">\n    <h3>Best Ways to Support Learning</h3>\n    <p>Encourage curiosity by offering varied ways to explore new ideas, allowing her to take her time with unfamiliar concepts. Providing choices in activities can empower her, and celebrating her effort, not just outcomes, helps build resilience.</p>\n  </div>\n\n  <div class=\"ai-card ai-card-activities\">\n    <h3>Encouraging Learning Atmosphere</h3>\n    <ul>\n      <li>Cultivate enthusiasm by connecting new learning to her interests and past successes.</li>\n      <li>Foster confidence through positive affirmations about her effort and problem-solving attempts.</li>\n      <li>Reduce pressure by emphasizing growth and fun over perfect performance.</li>\n    </ul>\n  </div>\n\n</div>', '2025-11-19 17:59:40', '2025-12-04 12:07:18');
INSERT INTO `ai_results` (`id`, `child_id`, `module`, `data`, `result`, `created_at`, `updated_at`) VALUES
(17, 12, 'learning_plan', '{\"scores\": [{\"subject\": \"English\", \"score\": 65, \"date\": \"2025-03-01\"}, {\"subject\": \"Mathematics\", \"score\": 95, \"date\": \"2025-03-01\"}, {\"subject\": \"Science\", \"score\": 80, \"date\": \"2025-03-01\"}, {\"subject\": \"Chinese\", \"score\": 80, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 40, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 50, \"date\": \"2025-06-01\"}, {\"subject\": \"Science\", \"score\": 90, \"date\": \"2025-06-01\"}, {\"subject\": \"Chinese\", \"score\": 85, \"date\": \"2025-06-01\"}, {\"subject\": \"English\", \"score\": 45, \"date\": \"2025-06-01\"}, {\"subject\": \"Mathematics\", \"score\": 90, \"date\": \"2025-06-01\"}, {\"subject\": \"Science\", \"score\": 100, \"date\": \"2025-09-01\"}, {\"subject\": \"Mathematics\", \"score\": 99, \"date\": \"2025-09-01\"}, {\"subject\": \"Malay\", \"score\": 45, \"date\": \"2025-09-01\"}, {\"subject\": \"Chinese\", \"score\": 90, \"date\": \"2025-09-01\"}, {\"subject\": \"English\", \"score\": 80, \"date\": \"2025-09-01\"}, {\"subject\": \"English\", \"score\": 30, \"date\": \"2025-12-01\"}], \"learning_result\": \"<h5>Learning Style Summary</h5>\\n<ul>\\n<li>Visual          : Strong, as they consistently prefer images, videos, and visual materials.</li>\\n<li>Auditory        : Moderate, as they enjoy discussions and sound-based games.</li>\\n<li>Reading/Writing : Moderate, as they show interest in written words and early literacy.</li>\\n<li>Kinesthetic     : Weak, as hands-on activities are not their primary learning preference.</li>\\n</ul>\\n\\n<h5>Main Learning Style</h5>\\n<p>Your child is primarily a visual learner, with developing strengths in auditory and early reading/writing styles.</p>\\n\\n<h6>Tips for Parents</h6>\\n<ul>\\n<li>Use plenty of pictures, videos, and visual aids when teaching new things.</li>\\n<li>Encourage discussions and ask questions to help your child process information.</li>\\n<li>Point out words and labels in books and daily life to nurture early reading skills.</li>\\n</ul>\", \"preschool_result\": \"<div style=\\\"font-family: Arial, sans-serif;\\\">\\n    <p><strong>Child\'s Age for Assessment:</strong> 68 months (5 years and 8 months)</p>\\n\\n    <h3 style=\\\"color: #4CAF50;\\\">Areas that are age-appropriate</h3>\\n    <ul>\\n        <li>No specific milestones were recorded as age-appropriate for Lam Ah Li at 68 months based on the provided data.</li>\\n    </ul>\\n\\n    <h3 style=\\\"color: #F44336;\\\">Areas that are delayed</h3>\\n    <ul>\\n        <li><strong>Movement/Physical Development:</strong> Lam Ah Li does not know how to walk at 68 months (5 years 8 months). Independent walking is typically achieved by 18 months. This represents a severe developmental delay in this area.</li>\\n        <li><strong>Social/Emotional Milestones:</strong> Lam Ah Li is recorded as \\\"Always not happy\\\" at 68 months. Typical social-emotional development for a child of this age includes expressing a range of emotions, engaging happily with others, and showing empathy. This observation suggests significant concerns regarding emotional well-being and social-emotional development.</li>\\n        <li><strong>Language/Communication:</strong> Although a \\\"test\\\" was recorded, no specific language achievements (e.g., telling stories, speaking in complex sentences, naming letters) are provided for Lam Ah Li at 68 months. For a child of this age, significant progress in verbal communication is expected. The absence of reported milestones suggests a likely delay in this area.</li>\\n    </ul>\\n\\n    <h3 style=\\\"color: #2196F3;\\\">Areas that are advanced for the child\'s age</h3>\\n    <ul>\\n        <li>No advanced milestones were recorded for Lam Ah Li based on the provided data.</li>\\n    </ul>\\n\\n    <p style=\\\"font-weight: bold; margin-top: 20px;\\\">\\n        Overall, Lam Ah Li demonstrates significant developmental delays in Movement/Physical Development and Social/Emotional Milestones, with concerns regarding Language/Communication based on the absence of reported age-appropriate achievements.\\n    </p>\\n</div>\", \"tutoring_result\": \"<h3>1. Potential Weak Areas</h3>\\n<ul>\\n  <li><strong>Gross Motor Skills:</strong> Lam Ah Li shows a severe delay in physical development, specifically not yet knowing how to walk at 5 years 8 months, which is significantly beyond the typical age for independent walking. This indicates a critical need for support in balance, coordination, and fundamental movement.</li>\\n  <li><strong>Emotional Regulation and Expression:</strong> The observation that Lam Ah Li is \\\"Always not happy\\\" suggests difficulties in managing and expressing a range of emotions in a positive and age-appropriate manner, impacting overall well-being.</li>\\n  <li><strong>Social Interaction and Engagement:</strong> Linked to emotional well-being, the lack of reported happy engagement indicates potential challenges in initiating and maintaining social interactions with others.</li>\\n  <li><strong>Expressive and Receptive Language Skills:</strong> The absence of specific reported language milestones at 5 years 8 months, despite a \\\"test,\\\" strongly suggests a delay in verbal communication, including vocabulary, sentence formation, and comprehension.</li>\\n</ul>\\n\\n<h3>2. Recommended Focus Areas</h3>\\n<ul>\\n  <li><strong>Physical Therapy and Gross Motor Development:</strong> Intensive support is crucial for developing foundational movement skills, including assisted walking, balance, and strengthening exercises.</li>\\n  <li><strong>Social-Emotional Learning:</strong> Activities designed to help Lam Ah Li identify, understand, and express her emotions, as well as fostering positive social interactions and happiness.</li>\\n  <li><strong>Language and Communication Development:</strong> Focused efforts on building vocabulary, encouraging verbal expression, improving listening comprehension, and fostering early literacy skills.</li>\\n</ul>\\n\\n<h3>3. Personalized Activities</h3>\\n<ul>\\n  <li><strong>Interactive Movement Videos & Music:</strong> Given her strong visual preference, play engaging children\'s videos with simple movements, dances, or exercises. Encourage her to watch and, with gentle assistance, mimic even small actions or gestures. Pair this with upbeat music to stimulate auditory senses and create a positive atmosphere.</li>\\n  <li><strong>\\\"Feelings Finder\\\" with Picture Cards:</strong> Use large, clear picture cards depicting various emotions (happy, sad, angry, surprised). Point to each card, name the emotion, and discuss what makes people feel that way. Encourage Lam Ah Li to point to how she feels or make corresponding facial expressions.</li>\\n  <li><strong>Visual Storytelling & Narration:</strong> Read highly visual picture books or watch short animated stories together. Pause frequently to point out objects, characters, and actions, naming them clearly. Narrate what is happening (\\\"The bird is flying up!\\\") and encourage her to respond with sounds, gestures, or words, building both language and visual comprehension.</li>\\n  <li><strong>\\\"Show Me\\\" Vocabulary Games:</strong> Use visual aids like flashcards or real objects. Name an item and ask Lam Ah Li to point to it (\\\"Show me the ball\\\"). Conversely, point to an item and ask \\\"What is this?\\\" This reinforces receptive and expressive language through visual cues.</li>\\n</ul>\\n\\n<h3>4. Recommended Learning Materials</h3>\\n<p>Here are specific products to support Lam Ah Li\'s learning:</p>\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n<p><strong>Parent Action Plan:</strong> Your immediate focus should be on consistently supporting Lam Ah Li\'s physical development with assisted movement, alongside creating a nurturing environment for emotional expression and social engagement. Actively integrate visual and auditory learning resources into daily routines to build her language skills and foster overall happiness.</p>\"}', '<div class=\"learning-plan\">\n  <h3>Weekly Action Plan</h3>\n  <table class=\"table table-striped\">\n    <thead>\n      <tr>\n        <th>Day</th>\n        <th>Recommended Activities</th>\n      </tr>\n    </thead>\n    <tbody>\n      <tr>\n        <td>Monday</td>\n        <td>\n          <ol>\n            <li>Interactive Movement Video (15 min) – Watch a children\'s video and try gentle movements with assistance.</li>\n            <li>\"My Feelings\" Picture Cards (10 min) – Identify and name emotions using picture cards, discussing how they feel.</li>\n            <li>Visual Storybook Exploration (20 min) – Read a picture book, pointing at items and naming them together.</li>\n          </ol>\n        </td>\n      </tr>\n      <tr>\n        <td>Tuesday</td>\n        <td>\n          <ol>\n            <li>Assisted Standing & Balance (15 min) – Practice standing with support, focusing on gentle balance movements.</li>\n            <li>Happy Sounds & Songs (10 min) – Listen to cheerful music and try to clap or hum along happily.</li>\n            <li>\"Show Me\" Object Game (15 min) – Use real objects to build vocabulary; parent names, child points.</li>\n          </ol>\n        </td>\n      </tr>\n      <tr>\n        <td>Wednesday</td>\n        <td>\n          <ol>\n            <li>Movement with Music (15 min) – Play upbeat songs and encourage simple arm or leg movements while seated or supported.</li>\n            <li>Mirror Emotions Game (10 min) – Make happy, sad, or surprised faces in a mirror and name them.</li>\n            <li>Animated Story Time (20 min) – Watch a short animated story, discussing characters and actions visually.</li>\n          </ol>\n        </td>\n      </tr>\n      <tr>\n        <td>Thursday</td>\n        <td>\n          <ol>\n            <li>Gentle Stretching Fun (15 min) – Follow simple visual cards for gentle stretches with parent assistance.</li>\n            <li>\"What Makes Me Happy?\" Talk (10 min) – Look at pictures of fun things and discuss what makes her smile.</li>\n            <li>Word Flashcard Match (15 min) – Match picture flashcards to spoken words, reinforcing vocabulary.</li>\n          </ol>\n        </td>\n      </tr>\n      <tr>\n        <td>Friday</td>\n        <td>\n          <ol>\n            <li>Balloon Tap (15 min) – Gently tap a soft balloon while seated or supported, improving coordination.</li>\n            <li>Role-Play Happy Moments (10 min) – Use dolls or toys to act out simple scenarios that bring joy.</li>\n            <li>\"Tell Me About It\" Pictures (20 min) – Look at interesting pictures and encourage her to describe what she sees.</li>\n          </ol>\n        </td>\n      </tr>\n      <tr>\n        <td>Saturday</td>\n        <td>\n          <ol>\n            <li>Assisted Crawling/Moving (15 min) – Encourage movement on the floor with parent support, exploring space.</li>\n            <li>Positive Affirmations (10 min) – Repeat simple, positive phrases like \"I am kind\" while looking in a mirror.</li>\n            <li>Outdoor Observation Walk (15 min) – Point out and name things seen during a short, supported outdoor observation.</li>\n          </ol>\n        </td>\n      </tr>\n      <tr>\n        <td>Sunday</td>\n        <td>\n          <ol>\n            <li>Family Dance Party (15 min) – Play favourite upbeat music and encourage any form of movement with family.</li>\n            <li>\"My Favourite Things\" Collage (15 min) – Create a collage of pictures that make her happy, discussing each item.</li>\n            <li>Visual Comprehension Game (15 min) – Use \"I Spy\" with objects, describing them to build listening skills.</li>\n          </ol>\n        </td>\n      </tr>\n    </tbody>\n  </table>\n\n  <h3>Long-Term Strategy</h3>\n  <ul>\n    <li>Maintain consistent daily engagement with short, regular activities to support physical, emotional, and language development.</li>\n    <li>Actively seek and follow professional guidance, especially for physiotherapy to address gross motor delays.</li>\n    <li>Cultivate a warm, nurturing home environment filled with visual aids and opportunities for positive social-emotional expression.</li>\n    <li>Integrate learning naturally into daily routines by pointing out words, discussing feelings, and encouraging communication.</li>\n    <li>Celebrate every small step of progress in movement, social interaction, and language to build confidence and happiness.</li>\n  </ul>\n</div>', '2025-11-19 18:14:20', '2025-12-10 07:08:17'),
(18, 12, 'resources', '{\"scores\": [{\"subject\": \"math\", \"score\": 60, \"date\": \"2022-06-01\"}, {\"subject\": \"english\", \"score\": 50, \"date\": \"2022-06-01\"}, {\"subject\": \"bm\", \"score\": 40, \"date\": \"2022-06-01\"}, {\"subject\": \"math\", \"score\": 80, \"date\": \"2022-03-01\"}, {\"subject\": \"english\", \"score\": 60, \"date\": \"2022-03-01\"}, {\"subject\": \"bm\", \"score\": 70, \"date\": \"2022-03-01\"}], \"learning_summary\": \"<p><strong>Most Likely Learning Style:</strong> Kinesthetic</p>\\n\\n<p>\\n    Based on the observation that the child \\\"cannot focus while study and learning at school,\\\" a kinesthetic learning style is the most likely.\\n    Kinesthetic learners thrive when they can move, touch, and interact physically with their learning environment to process information.\\n    Traditional classroom settings, which often require children to sit still for extended periods, can be particularly challenging for these active learners, leading to apparent difficulties with focus and attention.\\n    Their inherent need for movement and hands-on engagement is central to how they process and retain new information effectively.\\n</p>\\n\\n<h3>Actionable Suggestions:</h3>\\n<ul>\\n    <li>Integrate physical activity into lessons, such as movement breaks, standing desks, or learning games that involve gross motor skills.</li>\\n    <li>Provide hands-on learning opportunities using manipulatives, playdough, blocks, or other tactile materials to explore concepts.</li>\\n    <li>Encourage role-playing, experiments, and building activities where the child can actively participate and experience the learning content.</li>\\n    <li>Allow for frequent, short breaks where the child can stand up, stretch, or move around to help regulate their energy and attention.</li>\\n    <li>Utilize sensory bins or textured objects during quiet time activities to engage their tactile senses in a focused way.</li>\\n</ul>\", \"age\": 5, \"grade_level\": \"A\"}', '<h3>Suggested Resources Overview</h3>\nDear Parents, we\'ve put together a special collection of resources for Lam Ah Li that celebrates her energetic and hands-on learning style! Since Ah Li learns best by moving and doing, these activities are designed to be interactive and engaging. We\'ll focus on making learning Bahasa Malaysia and English fun and active, while also continuing to build on her developing math skills through playful exploration. Get ready to move, play, and discover together!\n\n<h3>Videos</h3>\n<ul>\n  <li><strong>Active Alphabet Action Song (English)</strong> – This lively video uses catchy songs and body movements to help your child learn and recognize English alphabet letters and their sounds. (Target skill: English letter recognition, phonics; approximate duration: 3-4 minutes; what parents should do: Encourage your child to sing along, mimic the actions, and even pause the video to practice forming the letters with their body or hands.)</li>\n  <li><strong>Gerak-Gerak Nombor (BM Counting Movement)</strong> – A fun Bahasa Malaysia video that teaches counting from 1 to 10 through simple, repetitive physical actions and songs. (Target skill: BM number recognition, counting, vocabulary; approximate duration: 4-5 minutes; what parents should do: Join in the movements and counts, repeating the BM words clearly. You can also point to objects around the room and count them in BM.)</li>\n  <li><strong>Shape Explorer Dance</strong> – This video encourages children to move their bodies to represent different shapes (e.g., making a circle with their arms, standing like a triangle) while identifying shapes found in their environment. (Target skill: Math - shape recognition, gross motor skills; approximate duration: 5 minutes; what parents should do: Participate with your child, helping them spot shapes around the house and encouraging creative movements for each shape.)</li>\n</ul>\n\n<h3>Games & Apps</h3>\n<ul>\n  <li><strong>Sensory Bin Letter & Number Hunt (Offline Game)</strong> – Create a large bin filled with rice, sand, or beans, and hide magnetic letters, number tiles, or small cut-out letters/numbers. Your child can use scoops or their hands to find and identify them. (Type: Offline game; target subject or skill: English/BM letter and number recognition, fine motor skills, tactile learning)</li>\n  <li><strong>Giant Floor Mat Race (Offline Game)</strong> – Use painter\'s tape to create a large number line or alphabet path on the floor. Call out a number or letter, and your child hops, skips, or crawls to it. (Type: Offline game; target subject or skill: Math - number sequencing, English/BM - letter recognition, gross motor skills)</li>\n  <li><strong>Play-Doh Story Creation (Offline Game)</strong> – Encourage your child to sculpt characters and objects from a simple story you tell in English or Bahasa Malaysia. They can act out parts of the story with their creations. (Type: Offline game; target subject or skill: English/BM vocabulary, storytelling, imaginative play, fine motor skills)</li>\n  <li><strong>Interactive Building Blocks App</strong> – A digital app that allows children to build and create structures using virtual blocks, often with challenges that involve spatial reasoning or following patterns. (Type: Mobile app / Digital game; target subject or skill: Math - spatial reasoning, problem-solving, creativity, basic physics concepts)</li>\n  <li><strong>Alphabet Tracing & Phonics Adventure</strong> – An app where children trace letters with their finger and hear the phonetic sound, often with mini-games involving matching sounds to words. (Type: Mobile app; target subject or skill: English/BM letter formation, phonics, vocabulary)</li>\n</ul>\n\n<h3>Books & Reading Materials</h3>\n<ul>\n  <li><strong>\"Busy Builders\" Lift-the-Flap Book</strong> – An interactive book where children lift flaps to discover hidden objects, numbers, or letters related to a building theme. (Reading level: Preschool; themes: Construction, discovery, numbers/letters; how it supports their learning: Encourages tactile exploration, prediction, and makes reading an active experience, engaging their kinesthetic style.)</li>\n  <li><strong>\"My First Bahasa Malaysia Words: An Action Book\"</strong> – A picture book with simple BM words and phrases, each paired with an action or movement the child can perform while reading. (Reading level: Preschool; themes: Everyday actions, BM vocabulary; how it supports their learning: Connects words to physical movements, enhancing memory and comprehension for BM.)</li>\n  <li><strong>\"Where\'s My _______?\" Sensory Board Book</strong> – Books with different textures for children to touch and feel as they search for a character or object on each page. (Reading level: Preschool; themes: Exploration, senses, animals/objects; how it supports their learning: Engages tactile senses, making reading a multi-sensory and interactive experience.)</li>\n  <li><strong>\"The Number Detective\" Interactive Picture Book</strong> – A storybook that encourages children to find and count specific objects on each page to help a character solve a mystery. (Reading level: Preschool; themes: Counting, observation, problem-solving; how it supports their learning: Turns reading into an active search-and-find game, reinforcing math skills in an engaging way.)</li>\n</ul>', '2025-11-19 18:33:21', '2025-11-20 04:01:36'),
(19, 13, 'preschool', '[{\"id\": 17, \"child_id\": 13, \"domain\": \"Language/Communication\", \"description\": \"cant talk\", \"date\": \"2023-01-01\", \"date_str\": \"2023-01\", \"age_months\": 12}]', '<p><strong>Developmental Summary for Chen (at 12 months of age)</strong></p>\n\n<p>Based on the provided milestones, here is a comparison of Chen\'s development to standard age-based benchmarks:</p>\n\n<ul>\n    <li>\n        <strong>Areas that are age-appropriate:</strong>\n        <p>No specific milestones were provided for Chen to assess age-appropriate development in other categories at 12 months.</p>\n    </li>\n    <li>\n        <strong>Areas that are delayed:</strong>\n        <ul>\n            <li><strong>Language/Communication:</strong> At 12 months, Chen \"cant talk.\" This indicates a significant delay compared to standard benchmarks, which typically include saying \"mama\" or \"dada\" and waving \"bye-bye\" by this age.</li>\n        </ul>\n    </li>\n    <li>\n        <strong>Areas that are advanced for the child\'s age:</strong>\n        <p>No specific milestones were provided to indicate advanced development in any category.</p>\n    </li>\n</ul>\n\n<p><strong>Overall Development Progress:</strong> Chen is experiencing a notable delay in language and communication development based on the available information.</p>', '2025-11-27 15:23:56', '2025-11-27 15:23:56'),
(20, 13, 'tutoring', '{\n  \"learning\": null,\n  \"preschool\": \"<p><strong>Developmental Summary for Chen (at 12 months of age)</strong></p>\\n\\n<p>Based on the provided milestones, here is a comparison of Chen\'s development to standard age-based benchmarks:</p>\\n\\n<ul>\\n    <li>\\n        <strong>Areas that are age-appropriate:</strong>\\n        <p>No specific milestones were provided for Chen to assess age-appropriate development in other categories at 12 months.</p>\\n    </li>\\n    <li>\\n        <strong>Areas that are delayed:</strong>\\n        <ul>\\n            <li><strong>Language/Communication:</strong> At 12 months, Chen \\\"cant talk.\\\" This indicates a significant delay compared to standard benchmarks, which typically include saying \\\"mama\\\" or \\\"dada\\\" and waving \\\"bye-bye\\\" by this age.</li>\\n        </ul>\\n    </li>\\n    <li>\\n        <strong>Areas that are advanced for the child\'s age:</strong>\\n        <p>No specific milestones were provided to indicate advanced development in any category.</p>\\n    </li>\\n</ul>\\n\\n<p><strong>Overall Development Progress:</strong> Chen is experiencing a notable delay in language and communication development based on the available information.</p>\"\n}', '<h3>Potential Weak Areas and Skills Needing Support</h3>\n<ul>\n    <li><strong>Language and Communication Development:</strong> Chen\'s inability to talk at 12 months is a key indicator of a delay in expressive language skills. This likely extends to pre-verbal communication skills such as babbling with consonant-vowel combinations, imitating sounds, and using gestures like waving or pointing.</li>\n    <li><strong>Receptive Language Skills:</strong> While not explicitly stated, expressive language delays can sometimes coincide with or impact receptive language development (understanding words and instructions). This area warrants close monitoring.</li>\n    <li><strong>Social Communication:</strong> The development of language is closely linked to social interaction. Delays in communication may indirectly affect social communication milestones, such as responding to their name, showing interest in others, or engaging in reciprocal play.</li>\n</ul>\n\n<h3>Subjects or Developmental Domains Where Tutoring or Extra Help Would Be Most Beneficial</h3>\n<ul>\n    <li><strong>Speech and Language Development:</strong> This is the primary domain requiring focused support. Early intervention with a Speech-Language Pathologist (SLP) is highly recommended to assess Chen\'s current communication skills comprehensively and to create a targeted intervention plan.</li>\n    <li><strong>Early Communication Skills:</strong> Emphasis should be placed on fostering foundational communication, including babbling, sound imitation, joint attention (sharing focus on an object or event), and the use of gestures.</li>\n</ul>\n\n<h3>Personalized Activity or Tutoring Style Recommendations</h3>\n<p>Given the lack of specific learning style data, the following recommendations are based on best practices for fostering language development in infants and should be adapted as Chen\'s preferences become clearer:</p>\n<ul>\n    <li><strong>Interactive and Responsive Communication:</strong> Engage Chen in frequent, face-to-face interactions. Respond to all of Chen\'s vocalizations (babbling, cooing) by imitating sounds, expanding on them (e.g., if Chen says \"ba,\" you say \"Ball! Big ball!\"), and narrating your actions throughout the day.</li>\n    <li><strong>Modeling and Repetition:</strong> Use simple, clear language. Point to objects and name them (\"ball,\" \"doggy,\" \"milk\"). Repeat words and phrases often, especially during routines like feeding, diaper changes, and play.</li>\n    <li><strong>Reading Aloud Daily:</strong> Read board books daily, pointing to pictures and naming them. Encourage Chen to interact with the book by turning pages or looking at specific illustrations. Choose books with bright colors and simple stories.</li>\n    <li><strong>Singing and Rhymes:</strong> Sing simple nursery rhymes and songs with actions (e.g., \"Pat-a-Cake,\" \"Itsy Bitsy Spider\"). The rhythm and repetition help with language acquisition.</li>\n    <li><strong>Gesture and Sign Language:</strong> Introduce simple gestures or baby signs for common words like \"more,\" \"all done,\" \"milk,\" and \"eat.\" This can reduce frustration and provide a bridge to spoken language.</li>\n    <li><strong>Play-Based Learning:</strong> Incorporate language into play. During playtime, describe what Chen is doing or what toys are being used (\"You\'re pushing the car,\" \"The block is red\"). Encourage turn-taking during play.</li>\n    <li><strong>Observation for Learning Style Clues:</strong> Pay close attention to how Chen responds to different types of stimulation. Does Chen seem more engaged by visual cues, sounds, movement, or hands-on activities? This will help tailor future interactions.</li>\n</ul>\n\n<p><strong>Summary for Parents:</strong> Chen is showing a notable delay in language and communication development, which is a critical area for early intervention. Seeking a professional evaluation and guidance from a Speech-Language Pathologist is the most crucial next step. Alongside professional support, consistent and engaging language-rich interactions at home, through activities like responsive talking, reading, singing, and play, will provide Chen with valuable opportunities to develop essential communication skills. Early support in this area is key to fostering overall developmental progress.</p>', '2025-11-27 15:24:27', '2025-11-27 15:24:27'),
(21, 13, 'insights', '{\"scores\": [{\"subject\": \"drawing\", \"score\": 90, \"date\": \"2025-01-01\"}, {\"subject\": \"Coloring\", \"score\": 80, \"date\": \"2025-03-01\"}]}', 'Dear Chen\'s Parents,\n\nIt\'s wonderful to see Chen\'s creativity blossoming at three years old! Chen shows a remarkable flair for artistic expression, especially in drawing, demonstrating a strong imaginative ability. While Chen\'s drawing is truly standout, we\'ve noticed that coloring skills are developing nicely and could benefit from a little more focused practice to build confidence. To gently support this at home, try offering a variety of coloring tools like chunky crayons or washable markers, and encourage filling in larger shapes or simple outlines together. You could also make it a fun game by talking about the colors as Chen uses them, celebrating every effort and splash of color.', '2025-11-27 15:24:39', '2025-11-27 15:24:39'),
(23, 12, 'learning', '{\n  \"observations\": [\n    {\n      \"id\": 11,\n      \"child_id\": 12,\n      \"observation\": \"my kid really likes to watch youtube cartoon and video in his daily life\",\n      \"created_at\": \"2025-11-30 23:04:58\"\n    }\n  ],\n  \"answers\": [\n    {\n      \"answer_id\": 96,\n      \"test_id\": 7,\n      \"question_id\": 42,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-11-30 22:55:14\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child likes to look at pictures, books, or charts when learning something new. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 97,\n      \"test_id\": 7,\n      \"question_id\": 43,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-11-30 22:55:14\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child remembers things better when seeing them rather than hearing them. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 98,\n      \"test_id\": 7,\n      \"question_id\": 44,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-11-30 22:55:14\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child is attracted to bright colours, drawings, and visual materials. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 99,\n      \"test_id\": 7,\n      \"question_id\": 45,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-11-30 22:55:14\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child often points to pictures or images when explaining something. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 100,\n      \"test_id\": 7,\n      \"question_id\": 46,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-11-30 22:55:14\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"If given a choice, my child prefers watching videos instead of only listening. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 91,\n      \"test_id\": 8,\n      \"question_id\": 37,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:55:07\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child enjoys listening to stories, songs, or rhymes. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 92,\n      \"test_id\": 8,\n      \"question_id\": 38,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:55:07\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child often repeats words or talks to themselves while learning. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 93,\n      \"test_id\": 8,\n      \"question_id\": 39,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:55:07\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child remembers instructions better when they are spoken instead of written. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 94,\n      \"test_id\": 8,\n      \"question_id\": 40,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-11-30 22:55:07\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child likes to ask questions and discuss topics out loud. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 95,\n      \"test_id\": 8,\n      \"question_id\": 41,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:55:07\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child enjoys sound-based games (songs, rhyming, clapping patterns). ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 86,\n      \"test_id\": 9,\n      \"question_id\": 52,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:54:58\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child likes to look at written words, labels, or simple text. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 87,\n      \"test_id\": 9,\n      \"question_id\": 53,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:54:58\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child enjoys tracing letters or copying simple words. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 88,\n      \"test_id\": 9,\n      \"question_id\": 54,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:54:58\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child points at words or follows with a finger while reading. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 89,\n      \"test_id\": 9,\n      \"question_id\": 55,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:54:58\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child asks what words say when they see text in books or on signs. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 90,\n      \"test_id\": 9,\n      \"question_id\": 56,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-11-30 22:54:58\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child prefers looking at written instructions instead of only listening. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 81,\n      \"test_id\": 10,\n      \"question_id\": 62,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:54:50\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child learns better when there is hands-on activity (drawing, building, playing). ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 82,\n      \"test_id\": 10,\n      \"question_id\": 63,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:54:50\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child often moves around or fidgets when learning. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 83,\n      \"test_id\": 10,\n      \"question_id\": 64,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:54:50\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child remembers things better after doing an activity. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 84,\n      \"test_id\": 10,\n      \"question_id\": 65,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:54:50\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child likes to touch and explore objects when they are curious. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 85,\n      \"test_id\": 10,\n      \"question_id\": 66,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-11-30 22:54:50\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child finds it hard to sit still for a long time during quiet learning. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    }\n  ]\n}', '<h5>Learning Style Summary</h5>\n<ul>\n<li>Visual          : Strong, as they consistently prefer images, videos, and visual materials.</li>\n<li>Auditory        : Moderate, as they enjoy discussions and sound-based games.</li>\n<li>Reading/Writing : Moderate, as they show interest in written words and early literacy.</li>\n<li>Kinesthetic     : Weak, as hands-on activities are not their primary learning preference.</li>\n</ul>\n\n<h5>Main Learning Style</h5>\n<p>Your child is primarily a visual learner, with developing strengths in auditory and early reading/writing styles.</p>\n\n<h6>Tips for Parents</h6>\n<ul>\n<li>Use plenty of pictures, videos, and visual aids when teaching new things.</li>\n<li>Encourage discussions and ask questions to help your child process information.</li>\n<li>Point out words and labels in books and daily life to nurture early reading skills.</li>\n</ul>', '2025-11-30 15:44:11', '2025-11-30 15:44:11'),
(24, 15, 'learning', '{\n  \"observations\": [],\n  \"answers\": [\n    {\n      \"answer_id\": 116,\n      \"test_id\": 7,\n      \"question_id\": 42,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-12-04 20:00:39\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child likes to look at pictures, books, or charts when learning something new. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 117,\n      \"test_id\": 7,\n      \"question_id\": 43,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-12-04 20:00:39\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child remembers things better when seeing them rather than hearing them. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 118,\n      \"test_id\": 7,\n      \"question_id\": 44,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-12-04 20:00:39\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child is attracted to bright colours, drawings, and visual materials. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 119,\n      \"test_id\": 7,\n      \"question_id\": 45,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-12-04 20:00:39\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"My child often points to pictures or images when explaining something. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 120,\n      \"test_id\": 7,\n      \"question_id\": 46,\n      \"answer\": \"2\",\n      \"created_at\": \"2025-12-04 20:00:39\",\n      \"test_name\": \"Visual Learning Questionnaire\",\n      \"question_text\": \"If given a choice, my child prefers watching videos instead of only listening. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 111,\n      \"test_id\": 8,\n      \"question_id\": 37,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:30\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child enjoys listening to stories, songs, or rhymes. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 112,\n      \"test_id\": 8,\n      \"question_id\": 38,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:30\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child often repeats words or talks to themselves while learning. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 113,\n      \"test_id\": 8,\n      \"question_id\": 39,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:30\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child remembers instructions better when they are spoken instead of written. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 114,\n      \"test_id\": 8,\n      \"question_id\": 40,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:30\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child likes to ask questions and discuss topics out loud. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 115,\n      \"test_id\": 8,\n      \"question_id\": 41,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:30\",\n      \"test_name\": \"Auditory Learning Questionnaire\",\n      \"question_text\": \"My child enjoys sound-based games (songs, rhyming, clapping patterns). ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"auditory\"\n    },\n    {\n      \"answer_id\": 106,\n      \"test_id\": 9,\n      \"question_id\": 52,\n      \"answer\": \"1\",\n      \"created_at\": \"2025-12-04 20:00:21\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child likes to look at written words, labels, or simple text. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 107,\n      \"test_id\": 9,\n      \"question_id\": 53,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:21\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child enjoys tracing letters or copying simple words. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 108,\n      \"test_id\": 9,\n      \"question_id\": 54,\n      \"answer\": \"5\",\n      \"created_at\": \"2025-12-04 20:00:21\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child points at words or follows with a finger while reading. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 109,\n      \"test_id\": 9,\n      \"question_id\": 55,\n      \"answer\": \"4\",\n      \"created_at\": \"2025-12-04 20:00:21\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child asks what words say when they see text in books or on signs. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 110,\n      \"test_id\": 9,\n      \"question_id\": 56,\n      \"answer\": \"2\",\n      \"created_at\": \"2025-12-04 20:00:21\",\n      \"test_name\": \"Reading/Writing Learning Questionnaire\",\n      \"question_text\": \"My child prefers looking at written instructions instead of only listening. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"reading\"\n    },\n    {\n      \"answer_id\": 101,\n      \"test_id\": 10,\n      \"question_id\": 62,\n      \"answer\": \"1\",\n      \"created_at\": \"2025-12-04 20:00:08\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child learns better when there is hands-on activity (drawing, building, playing). ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 102,\n      \"test_id\": 10,\n      \"question_id\": 63,\n      \"answer\": \"2\",\n      \"created_at\": \"2025-12-04 20:00:08\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child often moves around or fidgets when learning. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 103,\n      \"test_id\": 10,\n      \"question_id\": 64,\n      \"answer\": \"1\",\n      \"created_at\": \"2025-12-04 20:00:08\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child remembers things better after doing an activity. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 104,\n      \"test_id\": 10,\n      \"question_id\": 65,\n      \"answer\": \"2\",\n      \"created_at\": \"2025-12-04 20:00:08\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child likes to touch and explore objects when they are curious. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    },\n    {\n      \"answer_id\": 105,\n      \"test_id\": 10,\n      \"question_id\": 66,\n      \"answer\": \"3\",\n      \"created_at\": \"2025-12-04 20:00:08\",\n      \"test_name\": \"Kinesthetic Learning Questionnaire\",\n      \"question_text\": \"My child finds it hard to sit still for a long time during quiet learning. ( 1 : very disagree  -  5 : very agree)\",\n      \"question_category\": \"visual\"\n    }\n  ]\n}', '<h5>Learning Style Summary</h5>\n<ul>\n<li>Visual          : Moderate; enjoys pictures and uses them to explain.</li>\n<li>Auditory        : Strong; loves listening, talking, and sound-based activities.</li>\n<li>Reading/Writing : Strong; shows an active and emerging interest in letters and words.</li>\n<li>Kinesthetic     : Weak; does not prefer hands-on activities for learning.</li>\n</ul>\n\n<h5>Main Learning Style</h5>\n<p>This child primarily learns through listening and talking, with a clear interest in early reading and writing experiences.</p>\n\n<h6>Tips for Parents</h6>\n<ul>\n<li>Share stories, sing songs, and talk about new things often to engage their ears and voice.</li>\n<li>Offer chances to trace letters, point out words, and discuss text found in books or signs.</li>\n<li>Use picture books and visual aids, ensuring you also describe and discuss what is seen out loud.</li>\n</ul>', '2025-12-04 12:01:00', '2025-12-04 12:01:00');
INSERT INTO `ai_results` (`id`, `child_id`, `module`, `data`, `result`, `created_at`, `updated_at`) VALUES
(25, 15, 'tutoring', '{\n  \"learning\": \"<h5>Learning Style Summary</h5>\\n<ul>\\n<li>Visual          : Moderate; enjoys pictures and uses them to explain.</li>\\n<li>Auditory        : Strong; loves listening, talking, and sound-based activities.</li>\\n<li>Reading/Writing : Strong; shows an active and emerging interest in letters and words.</li>\\n<li>Kinesthetic     : Weak; does not prefer hands-on activities for learning.</li>\\n</ul>\\n\\n<h5>Main Learning Style</h5>\\n<p>This child primarily learns through listening and talking, with a clear interest in early reading and writing experiences.</p>\\n\\n<h6>Tips for Parents</h6>\\n<ul>\\n<li>Share stories, sing songs, and talk about new things often to engage their ears and voice.</li>\\n<li>Offer chances to trace letters, point out words, and discuss text found in books or signs.</li>\\n<li>Use picture books and visual aids, ensuring you also describe and discuss what is seen out loud.</li>\\n</ul>\",\n  \"preschool\": null\n}', '<h3>1. Potential Weak Areas</h3>\n<ul>\n  <li><strong>Kinesthetic Engagement:</strong> unreal lam shows a weak preference for hands-on activities for learning. While not necessarily a developmental delay, this indicates a need for gentle encouragement and structured exposure to tactile and movement-based learning to support overall development, including fine and gross motor skills.</li>\n  <li><strong>Exploration through Manipulation:</strong> Due to the weak kinesthetic preference, unreal lam might benefit from more opportunities to explore concepts by manipulating objects, building, or engaging in sensory play, which are crucial for early cognitive development.</li>\n</ul>\n\n<h3>2. Recommended Focus Areas</h3>\n<ul>\n  <li><strong>Early Literacy and Phonics:</strong> Building on unreal lam\'s strong interest in letters and words, and excellent auditory skills, focusing on phonological awareness, letter recognition, and early word building will be highly beneficial.</li>\n  <li><strong>Language and Auditory Comprehension:</strong> Leveraging the strong auditory learning style by enriching vocabulary, practicing listening skills, and encouraging expressive language through conversations and storytelling.</li>\n  <li><strong>Gentle Hands-on Exploration:</strong> Integrating simple, structured activities that involve manipulation and tactile engagement, linked with auditory and visual cues, to gradually build comfort and skill in kinesthetic learning.</li>\n</ul>\n\n<h3>3. Personalized Activities</h3>\n<ul>\n  <li><strong>Interactive Story Time:</strong> Read aloud frequently, using expressive voices for characters and discussing plot points, characters, and new words. Encourage unreal lam to predict what happens next or describe what is seen in the pictures.</li>\n  <li><strong>Sound and Letter Games:</strong> Play \"I Spy\" with letter sounds (\"I spy something that starts with /b/\"). Sing alphabet songs and rhyming songs, encouraging unreal lam to make up new rhymes.</li>\n  <li><strong>Letter Tracing and Building:</strong> Provide opportunities to trace large letters with a finger in sand, shaving cream, or on a simple wipe-clean board while sounding out the letters. Use magnetic letters to build simple words on a fridge or board.</li>\n  <li><strong>Audio Adventures:</strong> Listen to age-appropriate audiobooks or educational podcasts together during quiet time or car rides, followed by discussions about the story or concepts introduced.</li>\n  <li><strong>Picture-Word Matching:</strong> Use flashcards with clear pictures and words, discussing each item\'s name, sound, and the letters that form the word.</li>\n</ul>\n\n<h3>4. Recommended Learning Materials</h3>\n<p>Here are specific products to support unreal lam\'s learning:</p>\n\n\n\n\n\n\n\n\n\n<p><strong>Parent Action Plan:</strong> Focus immediately on nurturing unreal lam\'s strong auditory and emerging reading/writing skills through consistent story-sharing, letter games, and exposure to engaging educational audio. Simultaneously, gently introduce simple, visually supported hands-on activities like tracing or magnetic letter play to encourage kinesthetic development in a comfortable way.</p>', '2025-12-04 12:02:22', '2025-12-04 12:02:22'),
(26, 15, 'insights', '{\"scores\": [{\"subject\": \"English\", \"score\": 0, \"date\": \"2025-01-01\"}, {\"subject\": \"Science\", \"score\": 67, \"date\": \"2025-01-01\"}, {\"subject\": \"Chinese\", \"score\": 60, \"date\": \"2025-01-01\"}, {\"subject\": \"Mathematics\", \"score\": 6, \"date\": \"2025-01-01\"}, {\"subject\": \"Malay\", \"score\": 100, \"date\": \"2025-01-01\"}, {\"subject\": \"Science\", \"score\": 40, \"date\": \"2025-03-01\"}, {\"subject\": \"Mathematics\", \"score\": 25, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 100, \"date\": \"2025-03-01\"}, {\"subject\": \"Chinese\", \"score\": 70, \"date\": \"2025-03-01\"}, {\"subject\": \"English\", \"score\": 5, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 100, \"date\": \"2025-06-01\"}, {\"subject\": \"Chinese\", \"score\": 69, \"date\": \"2025-06-01\"}, {\"subject\": \"Mathematics\", \"score\": 100, \"date\": \"2025-06-01\"}, {\"subject\": \"English\", \"score\": 60, \"date\": \"2025-06-01\"}, {\"subject\": \"Science\", \"score\": 99, \"date\": \"2025-06-01\"}], \"games\": [{\"id\": 12, \"child_id\": 15, \"game_id\": 3, \"score\": 2, \"total_questions\": 5, \"time_spent_seconds\": 11, \"played_at\": \"2025-12-10 15:22:20\", \"game_title\": \"Animal Spelling\", \"game_key\": \"spelling_animals\"}, {\"id\": 13, \"child_id\": 15, \"game_id\": 2, \"score\": 3, \"total_questions\": 5, \"time_spent_seconds\": 13, \"played_at\": \"2025-12-10 15:22:36\", \"game_title\": \"Animal Vocabulary\", \"game_key\": \"vocab_animals\"}, {\"id\": 14, \"child_id\": 15, \"game_id\": 1, \"score\": 3, \"total_questions\": 5, \"time_spent_seconds\": 9, \"played_at\": \"2025-12-10 15:22:53\", \"game_title\": \"Counting Animals\", \"game_key\": \"counting_animals\"}]}', '<div class=\"ai-report-cards\">\n\n  <div class=\"ai-card ai-card-snapshot\">\n    <h3>Learning Personality Summary</h3>\n    <ul>\n      <li><strong>Thinking style:</strong> Unreal lam shows an intuitive and exploratory thinking style, often grasping new ideas quickly when they spark interest.</li>\n      <li><strong>Motivation patterns:</strong> Driven by curiosity, especially when topics align with existing knowledge or immediate interests. There\'s clear joy in mastery.</li>\n      <li><strong>Supportive environment:</strong> Thrives in playful, interactive settings where learning feels like discovery, and there\'s a good rhythm of engagement.</li>\n    </ul>\n  </div>\n\n  <div class=\"ai-card ai-card-strengths\">\n    <h3>Learning Strengths</h3>\n    <ul>\n      <li>Unreal lam has a wonderful capacity for mastery, especially when highly engaged, demonstrating strong retention and the ability to connect with concepts.</li>\n      <li>Shows a quick, responsive approach to interactive tasks and has the potential for significant leaps in understanding.</li>\n    </ul>\n  </div>\n\n  <div class=\"ai-card ai-card-areas\">\n    <h3>Challenges & Frustration Triggers</h3>\n    <ul>\n      <li>Unreal lam might lose focus or feel less motivated when tasks don\'t immediately capture imagination or require prolonged, abstract effort.</li>\n      <li>Unfamiliar concepts might initially lead to disengagement, requiring patient and playful introduction.</li>\n    </ul>\n  </div>\n\n  <div class=\"ai-card ai-card-style\">\n    <h3>Best Ways to Support Learning</h3>\n    <p>Encourage exploration by offering choices in activities and connecting new ideas to things unreal lam already loves. Celebrate effort and the process of discovery more than perfect answers. Allow for varied pacing and natural breaks to maintain engagement.</p>\n  </div>\n\n  <div class=\"ai-card ai-card-activities\">\n    <h3>Encouraging Learning Atmosphere</h3>\n    <ul>\n      <li>Foster enthusiasm by making learning a joyful adventure, linking new concepts to everyday play.</li>\n      <li>Build confidence by acknowledging all attempts and efforts, valuing curiosity and the journey of trying.</li>\n      <li>Minimize pressure by focusing on the fun of trying and learning, rather than strictly on performance.</li>\n    </ul>\n  </div>\n\n</div>', '2025-12-04 12:03:06', '2025-12-10 08:06:44'),
(27, 15, 'learning_plan', '{\"scores\": [{\"subject\": \"English\", \"score\": 0, \"date\": \"2025-01-01\"}, {\"subject\": \"Science\", \"score\": 67, \"date\": \"2025-01-01\"}, {\"subject\": \"Chinese\", \"score\": 60, \"date\": \"2025-01-01\"}, {\"subject\": \"Mathematics\", \"score\": 6, \"date\": \"2025-01-01\"}, {\"subject\": \"Malay\", \"score\": 100, \"date\": \"2025-01-01\"}, {\"subject\": \"Science\", \"score\": 40, \"date\": \"2025-03-01\"}, {\"subject\": \"Mathematics\", \"score\": 25, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 100, \"date\": \"2025-03-01\"}, {\"subject\": \"Chinese\", \"score\": 70, \"date\": \"2025-03-01\"}, {\"subject\": \"English\", \"score\": 5, \"date\": \"2025-03-01\"}, {\"subject\": \"Malay\", \"score\": 100, \"date\": \"2025-06-01\"}, {\"subject\": \"Chinese\", \"score\": 69, \"date\": \"2025-06-01\"}, {\"subject\": \"Mathematics\", \"score\": 100, \"date\": \"2025-06-01\"}, {\"subject\": \"English\", \"score\": 60, \"date\": \"2025-06-01\"}, {\"subject\": \"Science\", \"score\": 99, \"date\": \"2025-06-01\"}], \"learning_result\": \"<h5>Learning Style Summary</h5>\\n<ul>\\n<li>Visual          : Moderate; enjoys pictures and uses them to explain.</li>\\n<li>Auditory        : Strong; loves listening, talking, and sound-based activities.</li>\\n<li>Reading/Writing : Strong; shows an active and emerging interest in letters and words.</li>\\n<li>Kinesthetic     : Weak; does not prefer hands-on activities for learning.</li>\\n</ul>\\n\\n<h5>Main Learning Style</h5>\\n<p>This child primarily learns through listening and talking, with a clear interest in early reading and writing experiences.</p>\\n\\n<h6>Tips for Parents</h6>\\n<ul>\\n<li>Share stories, sing songs, and talk about new things often to engage their ears and voice.</li>\\n<li>Offer chances to trace letters, point out words, and discuss text found in books or signs.</li>\\n<li>Use picture books and visual aids, ensuring you also describe and discuss what is seen out loud.</li>\\n</ul>\", \"preschool_result\": null, \"tutoring_result\": \"<h3>1. Potential Weak Areas</h3>\\n<ul>\\n  <li><strong>Kinesthetic Engagement:</strong> unreal lam shows a weak preference for hands-on activities for learning. While not necessarily a developmental delay, this indicates a need for gentle encouragement and structured exposure to tactile and movement-based learning to support overall development, including fine and gross motor skills.</li>\\n  <li><strong>Exploration through Manipulation:</strong> Due to the weak kinesthetic preference, unreal lam might benefit from more opportunities to explore concepts by manipulating objects, building, or engaging in sensory play, which are crucial for early cognitive development.</li>\\n</ul>\\n\\n<h3>2. Recommended Focus Areas</h3>\\n<ul>\\n  <li><strong>Early Literacy and Phonics:</strong> Building on unreal lam\'s strong interest in letters and words, and excellent auditory skills, focusing on phonological awareness, letter recognition, and early word building will be highly beneficial.</li>\\n  <li><strong>Language and Auditory Comprehension:</strong> Leveraging the strong auditory learning style by enriching vocabulary, practicing listening skills, and encouraging expressive language through conversations and storytelling.</li>\\n  <li><strong>Gentle Hands-on Exploration:</strong> Integrating simple, structured activities that involve manipulation and tactile engagement, linked with auditory and visual cues, to gradually build comfort and skill in kinesthetic learning.</li>\\n</ul>\\n\\n<h3>3. Personalized Activities</h3>\\n<ul>\\n  <li><strong>Interactive Story Time:</strong> Read aloud frequently, using expressive voices for characters and discussing plot points, characters, and new words. Encourage unreal lam to predict what happens next or describe what is seen in the pictures.</li>\\n  <li><strong>Sound and Letter Games:</strong> Play \\\"I Spy\\\" with letter sounds (\\\"I spy something that starts with /b/\\\"). Sing alphabet songs and rhyming songs, encouraging unreal lam to make up new rhymes.</li>\\n  <li><strong>Letter Tracing and Building:</strong> Provide opportunities to trace large letters with a finger in sand, shaving cream, or on a simple wipe-clean board while sounding out the letters. Use magnetic letters to build simple words on a fridge or board.</li>\\n  <li><strong>Audio Adventures:</strong> Listen to age-appropriate audiobooks or educational podcasts together during quiet time or car rides, followed by discussions about the story or concepts introduced.</li>\\n  <li><strong>Picture-Word Matching:</strong> Use flashcards with clear pictures and words, discussing each item\'s name, sound, and the letters that form the word.</li>\\n</ul>\\n\\n<h3>4. Recommended Learning Materials</h3>\\n<p>Here are specific products to support unreal lam\'s learning:</p>\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n<p><strong>Parent Action Plan:</strong> Focus immediately on nurturing unreal lam\'s strong auditory and emerging reading/writing skills through consistent story-sharing, letter games, and exposure to engaging educational audio. Simultaneously, gently introduce simple, visually supported hands-on activities like tracing or magnetic letter play to encourage kinesthetic development in a comfortable way.</p>\"}', '<h3>Weekly Action Plan</h3>\n<table class=\"table table-striped\">\n  <thead>\n    <tr><th>Day</th><th>Recommended Activities</th></tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Monday</td>\n      <td>\n        <ol>\n          <li>Interactive Story Time (15 min) – Read aloud, discussing characters and new words with expressive voices.</li>\n          <li>Sound and Letter Hunt (10 min) – Play \"I Spy\" with letter sounds around the house or from a book.</li>\n          <li>Gentle Letter Tracing (15 min) – Trace large letters in sand or on a wipe-clean board while sounding them out.</li>\n        </ol>\n      </td>\n    </tr>\n    <tr>\n      <td>Tuesday</td>\n      <td>\n        <ol>\n          <li>Audio Story Adventure (20 min) – Listen to an age-appropriate audiobook or educational podcast, then discuss.</li>\n          <li>Picture-Word Matching (15 min) – Match flashcards with clear pictures to their printed names.</li>\n          <li>Rhyming Word Play (10 min) – Sing rhyming songs and take turns suggesting new rhyming words.</li>\n        </ol>\n      </td>\n    </tr>\n    <tr>\n      <td>Wednesday</td>\n      <td>\n        <ol>\n          <li>Expressive Storytelling (15 min) – Look at pictures in a book and create your own story together.</li>\n          <li>Magnetic Letter Building (15 min) – Use magnetic letters to spell simple words or recognize letters on a board.</li>\n          <li>\"What Do You Hear?\" Game (10 min) – Listen to sounds around you, identify them, and discuss what made them.</li>\n        </ol>\n      </td>\n    </tr>\n    <tr>\n      <td>Thursday</td>\n      <td>\n        <ol>\n          <li>Conversation Time (20 min) – Talk about your day, describe things you see, and ask open-ended questions.</li>\n          <li>Letter Drawing Fun (15 min) – Draw letters on paper, then color them while practicing their sounds.</li>\n          <li>Song & Movement (10 min) – Sing action songs or nursery rhymes, gently encouraging some simple movements.</li>\n        </ol>\n      </td>\n    </tr>\n    <tr>\n      <td>Friday</td>\n      <td>\n        <ol>\n          <li>Story Time with Predictions (15 min) – Read a book, pausing to ask \"What do you think happens next?\"</li>\n          <li>Letter Recognition Game (10 min) – Point out letters on signs, cereal boxes, or books during daily activities.</li>\n          <li>Sound and Object Match (15 min) – Find small objects, say their names, and identify their starting sound.</li>\n        </ol>\n      </td>\n    </tr>\n    <tr>\n      <td>Saturday</td>\n      <td>\n        <ol>\n          <li>Creative Language Play (20 min) – Invent a silly story together, each taking turns adding a sentence.</li>\n          <li>Visual Word Search (15 min) – Find specific letters or words in a favorite picture book.</li>\n          <li>Guided Sensory Play (10 min) – Explore textures like playdough or water with toys, describing what you feel.</li>\n        </ol>\n      </td>\n    </tr>\n    <tr>\n      <td>Sunday</td>\n      <td>\n        <ol>\n          <li>Family Read-Aloud (20 min) – Enjoy a longer story as a family, discussing the plot and characters.</li>\n          <li>Alphabet Song Variation (10 min) – Sing the alphabet song slowly, pointing to each letter as you sing it.</li>\n          <li>Review Favorite Activities (15 min) – Revisit unreal lam\'s favorite activity from the week, reinforcing learning.</li>\n        </ol>\n      </td>\n    </tr>\n  </tbody>\n</table>\n\n<h3>Long-Term Strategy</h3>\n<ul>\n  <li>Maintain a consistent routine of daily interactive story time and conversations to nurture strong auditory and language skills.</li>\n  <li>Continuously encourage interest in letters and words by pointing them out in everyday life and providing simple writing tools.</li>\n  <li>Gently integrate short, structured hands-on activities, like tracing or building with blocks, connecting them to what is seen or heard.</li>\n  <li>Utilize age-appropriate audiobooks and educational songs regularly to expand vocabulary and listening comprehension.</li>\n  <li>Celebrate all efforts and progress in learning, focusing on engagement and joy rather than perfection.</li>\n</ul>', '2025-12-04 12:04:10', '2025-12-10 06:43:51');

-- --------------------------------------------------------

--
-- Table structure for table `children`
--

CREATE TABLE `children` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `dob` date NOT NULL,
  `age` int(11) DEFAULT NULL,
  `grade_level` varchar(50) DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `children`
--

INSERT INTO `children` (`id`, `parent_id`, `name`, `dob`, `age`, `grade_level`, `gender`, `notes`, `created_at`) VALUES
(10, 7, 'mee', '2023-01-02', 2, 'a', 'female', '', '2025-10-09 15:20:43'),
(11, 7, 'Tong Yi Wen', '2023-10-19', 3, 'b', 'female', '', '2025-10-13 15:55:36'),
(12, 9, 'Lam Ah Li', '2020-03-01', 5, 'A', 'female', '', '2025-11-18 18:17:18'),
(13, 13, 'Chen', '2022-01-19', 3, 'b', 'male', '', '2025-11-27 15:21:50'),
(14, 13, 'Yan Yan', '2021-01-11', 4, 'K1', 'female', '', '2025-11-27 15:22:33'),
(15, 9, 'unreal lam', '2022-03-03', 3, 'zzz', 'male', '', '2025-12-04 11:54:47'),
(16, 17, 'EZ Lam ', '2025-12-10', 4, 'aaa', 'female', '', '2025-12-10 10:44:38'),
(17, 18, 'Max', '2025-12-10', 3, 'b', 'female', '', '2025-12-10 10:53:21');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `game_key` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `age_min` int(11) DEFAULT NULL,
  `age_max` int(11) DEFAULT NULL,
  `difficulty` enum('easy','medium','hard') DEFAULT 'easy',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `url` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `title`, `game_key`, `description`, `age_min`, `age_max`, `difficulty`, `is_active`, `url`, `created_at`, `updated_at`) VALUES
(1, 'Counting Animals', 'counting_animals', 'Simple counting game where children count animals and choose the correct number.', 3, 6, 'easy', 1, NULL, '2025-11-29 01:46:11', '2025-12-10 14:57:40'),
(2, 'Animal Vocabulary', 'vocab_animals', 'Match the animal picture with the correct English word.', 4, 6, 'easy', 1, NULL, '2025-11-29 08:49:20', '2025-12-10 14:57:35'),
(3, 'Animal Spelling', 'spelling_animals', 'Fill in the missing letter to spell the animal name.', 4, 7, 'easy', 1, NULL, '2025-11-29 09:11:25', '2025-12-10 14:57:50');

-- --------------------------------------------------------

--
-- Table structure for table `game_results`
--

CREATE TABLE `game_results` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `total_questions` int(11) DEFAULT NULL,
  `time_spent_seconds` int(11) DEFAULT NULL,
  `played_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `game_results`
--

INSERT INTO `game_results` (`id`, `child_id`, `game_id`, `score`, `total_questions`, `time_spent_seconds`, `played_at`) VALUES
(1, 12, 1, 4, 5, 40, '2025-11-29 02:08:09'),
(2, 12, 1, 5, 5, 59, '2025-11-29 08:12:05'),
(3, 12, 1, 5, 5, 59, '2025-11-29 08:22:14'),
(4, 12, 2, 4, 5, 22, '2025-11-29 08:49:52'),
(5, 12, 3, 5, 5, 19, '2025-11-29 09:12:13'),
(6, 12, 3, 5, 5, 15, '2025-11-29 09:13:13'),
(7, 12, 3, 5, 5, 16, '2025-11-29 09:28:14'),
(8, 12, 2, 5, 5, 14, '2025-11-29 09:28:33'),
(9, 12, 1, 4, 5, 20, '2025-11-29 09:28:57'),
(10, 12, 3, 3, 5, 22, '2025-11-29 12:06:09'),
(11, 12, 3, 3, 5, 25, '2025-12-04 20:06:59'),
(12, 15, 3, 2, 5, 11, '2025-12-10 15:22:20'),
(13, 15, 2, 3, 5, 13, '2025-12-10 15:22:36'),
(14, 15, 1, 3, 5, 9, '2025-12-10 15:22:53');

-- --------------------------------------------------------

--
-- Table structure for table `learning_observations`
--

CREATE TABLE `learning_observations` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `observation` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `learning_observations`
--

INSERT INTO `learning_observations` (`id`, `child_id`, `observation`, `created_at`) VALUES
(4, 10, 'ABC', '2025-10-09 23:25:04'),
(8, 11, 'hand on activities', '2025-10-17 14:23:48'),
(11, 12, 'my kid really likes to watch youtube cartoon and video in his daily life', '2025-11-30 23:04:58');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `child_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('AI_INSIGHT','SCORE_ALERT','GAME_ALERT','LEARNING_PLAN','SYSTEM','REMINDER') NOT NULL DEFAULT 'SYSTEM',
  `priority` enum('LOW','NORMAL','HIGH') NOT NULL DEFAULT 'NORMAL',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `is_archived` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL,
  `link_type` enum('AI_INSIGHT','SCORES','GAME','LEARNING_PLAN','RESOURCES','CUSTOM') DEFAULT NULL,
  `link_id` int(11) DEFAULT NULL,
  `link_url` varchar(512) DEFAULT NULL,
  `created_by_admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `parent_id`, `child_id`, `title`, `message`, `type`, `priority`, `is_read`, `is_archived`, `created_at`, `read_at`, `link_type`, `link_id`, `link_url`, `created_by_admin_id`) VALUES
(1, 9, NULL, 'Test Notification', 'This is a test notification to check the module.', 'SYSTEM', 'NORMAL', 1, 1, '2025-12-10 16:52:44', '2025-12-10 18:14:01', NULL, NULL, NULL, NULL),
(2, 9, 12, 'Today’s learning plan for Lam Ah Li', 'Today is Wednesday. Please follow the activities for Wednesday in Lam Ah Li\'s Weekly Learning Plan.', 'LEARNING_PLAN', 'NORMAL', 1, 0, '2025-12-10 17:57:15', '2025-12-10 18:13:47', 'LEARNING_PLAN', NULL, '/dashboard/plan', NULL),
(3, 9, 15, 'Today’s learning plan for unreal lam', 'Today is Wednesday. Please follow the activities for Wednesday in unreal lam\'s Weekly Learning Plan.', 'LEARNING_PLAN', 'NORMAL', 1, 0, '2025-12-10 18:00:28', '2025-12-10 18:13:53', 'LEARNING_PLAN', NULL, '/dashboard/plan', NULL),
(4, 7, NULL, 'System Maintenance', 'ChildGrowth Insights will be unavailable tonight from 10pm–11pm.', 'SYSTEM', 'NORMAL', 0, 0, '2025-12-10 18:28:31', NULL, NULL, NULL, NULL, 11),
(5, 9, NULL, 'System Maintenance', 'ChildGrowth Insights will be unavailable tonight from 10pm–11pm.', 'SYSTEM', 'NORMAL', 1, 0, '2025-12-10 18:28:31', '2025-12-10 18:29:11', NULL, NULL, NULL, 11),
(6, 13, NULL, 'System Maintenance', 'ChildGrowth Insights will be unavailable tonight from 10pm–11pm.', 'SYSTEM', 'NORMAL', 0, 0, '2025-12-10 18:28:31', NULL, NULL, NULL, NULL, 11),
(7, 16, NULL, 'System Maintenance', 'ChildGrowth Insights will be unavailable tonight from 10pm–11pm.', 'SYSTEM', 'NORMAL', 0, 0, '2025-12-10 18:28:31', NULL, NULL, NULL, NULL, 11),
(8, 7, NULL, 'New Video resource: Fun with Numbers: Counting 1–10', 'A new Video resource \"Fun with Numbers: Counting 1–10\" has been added in the Educational Resources Hub. Open the hub to explore it.', '', 'NORMAL', 0, 0, '2025-12-10 18:40:07', NULL, 'RESOURCES', NULL, '/dashboard/resources', NULL),
(9, 9, NULL, 'New Video resource: Fun with Numbers: Counting 1–10', 'A new Video resource \"Fun with Numbers: Counting 1–10\" has been added in the Educational Resources Hub. Open the hub to explore it.', '', 'NORMAL', 1, 0, '2025-12-10 18:40:07', '2025-12-10 18:41:09', 'RESOURCES', NULL, '/dashboard/resources', NULL),
(10, 13, NULL, 'New Video resource: Fun with Numbers: Counting 1–10', 'A new Video resource \"Fun with Numbers: Counting 1–10\" has been added in the Educational Resources Hub. Open the hub to explore it.', '', 'NORMAL', 0, 0, '2025-12-10 18:40:08', NULL, 'RESOURCES', NULL, '/dashboard/resources', NULL),
(11, 16, NULL, 'New Video resource: Fun with Numbers: Counting 1–10', 'A new Video resource \"Fun with Numbers: Counting 1–10\" has been added in the Educational Resources Hub. Open the hub to explore it.', '', 'NORMAL', 0, 0, '2025-12-10 18:40:08', NULL, 'RESOURCES', NULL, '/dashboard/resources', NULL),
(12, 17, 16, 'Today’s learning plan for EZ Lam ', 'Today is Wednesday. Please follow the activities for Wednesday in EZ Lam \'s Weekly Learning Plan.', 'LEARNING_PLAN', 'NORMAL', 0, 1, '2025-12-10 18:44:44', NULL, 'LEARNING_PLAN', NULL, '/dashboard/plan', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `preschool_assessments`
--

CREATE TABLE `preschool_assessments` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `domain` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `preschool_assessments`
--

INSERT INTO `preschool_assessments` (`id`, `child_id`, `domain`, `description`, `date`) VALUES
(4, 10, 'Social/Emotional Milestones', 'ASSESSMENT', '2025-10-01'),
(10, 10, 'Cognitive Milestones', 'observation', '2025-11-01'),
(11, 10, 'Cognitive Milestones', 'observation', '2025-11-01'),
(12, 10, 'Cognitive Milestones', 'observation', '2025-11-01'),
(14, 12, 'Language/Communication', 'test', '2025-11-01'),
(15, 12, 'Movement/Physical Development', 'My child do not know how to walk even she is 5 years old', '2025-11-01'),
(16, 12, 'Social/Emotional Milestones', 'Always not happy', '2025-11-01'),
(17, 13, 'Language/Communication', 'cant talk', '2023-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `product_recommendations`
--

CREATE TABLE `product_recommendations` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `tutoring_result_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` enum('book','learning_tool','stationery','toy','app','subscription','workbook','flashcard','game') NOT NULL,
  `category` enum('books','art_craft','math_tools','stationery','educational_toys','digital_apps','other') DEFAULT 'other',
  `subject` enum('mathematics','english','science','social_emotional','physical_development','general') DEFAULT 'general',
  `learning_style` enum('visual','auditory','kinesthetic','reading_writing','mixed') DEFAULT 'mixed',
  `description` text DEFAULT NULL,
  `age_range` varchar(50) DEFAULT NULL,
  `price_myr` decimal(10,2) DEFAULT NULL,
  `price_range` enum('budget','mid_range','premium') DEFAULT 'budget',
  `amazon_url` varchar(500) DEFAULT NULL,
  `shopee_url` varchar(500) DEFAULT NULL,
  `lazada_url` varchar(500) DEFAULT NULL,
  `other_url` varchar(500) DEFAULT NULL,
  `priority` enum('high','medium','low') DEFAULT 'medium',
  `reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_recommendations`
--

INSERT INTO `product_recommendations` (`id`, `child_id`, `tutoring_result_id`, `product_name`, `product_type`, `category`, `subject`, `learning_style`, `description`, `age_range`, `price_myr`, `price_range`, `amazon_url`, `shopee_url`, `lazada_url`, `other_url`, `priority`, `reason`, `created_at`, `updated_at`) VALUES
(1, 12, NULL, 'VTech Sit-to-Stand Learning Walker', 'learning_tool', 'educational_toys', 'physical_development', 'mixed', '\"VTech walker,\" \"baby push walker learning,\" \"sit to stand activity center\"', '9 months - 3 years', 189.00, 'premium', 'https://www.amazon.com/s?k=%22VTech+walker%2C%22+%22baby+push+walker+learning%2C%22+%22sit+to+stand+activity+center%22', 'https://shopee.com.my/search?keyword=%22VTech+walker%2C%22+%22baby+push+walker+learning%2C%22+%22sit+to+stand+activity+center%22', 'https://www.lazada.com.my/catalog/?q=%22VTech+walker%2C%22+%22baby+push+walker+learning%2C%22+%22sit+to+stand+activity+center%22', NULL, 'high', 'Provides stable support for early walking attempts, crucial for her severe motor delay. It also includes engaging visual and auditory activities on the front panel to encourage interaction, language development (songs, phrases), and cognitive engagement.', '2025-12-01 09:49:43', '2025-12-01 09:49:43'),
(2, 12, NULL, 'The Feelings Book by Todd Parr', 'book', 'books', 'social_emotional', 'visual', '\"feelings book for toddlers,\" \"emotion picture book kids,\" \"social emotional learning book\"', '3-6 years', 45.00, 'mid_range', 'https://www.amazon.com/s?k=%22feelings+book+for+toddlers%2C%22+%22emotion+picture+book+kids%2C%22+%22social+emotional+learning+book%22', 'https://shopee.com.my/search?keyword=%22feelings+book+for+toddlers%2C%22+%22emotion+picture+book+kids%2C%22+%22social+emotional+learning+book%22', 'https://www.lazada.com.my/catalog/?q=%22feelings+book+for+toddlers%2C%22+%22emotion+picture+book+kids%2C%22+%22social+emotional+learning+book%22', NULL, 'high', 'This book uses simple language and bright, engaging illustrations to help children identify and understand a wide range of emotions, directly addressing Lam Ah Li\'s \"always not happy\" observation and fostering emotional literacy.', '2025-12-01 09:49:43', '2025-12-01 09:49:43'),
(3, 12, NULL, 'Usborne First 100 Words Lift-the-Flap Book', 'book', 'books', 'english', 'visual', '\"first words lift flap book,\" \"toddler vocabulary book,\" \"picture dictionary preschool\"', '1-4 years', 65.00, 'premium', 'https://www.amazon.com/s?k=%22first+words+lift+flap+book%2C%22+%22toddler+vocabulary+book%2C%22+%22picture+dictionary+preschool%22', 'https://shopee.com.my/search?keyword=%22first+words+lift+flap+book%2C%22+%22toddler+vocabulary+book%2C%22+%22picture+dictionary+preschool%22', 'https://www.lazada.com.my/catalog/?q=%22first+words+lift+flap+book%2C%22+%22toddler+vocabulary+book%2C%22+%22picture+dictionary+preschool%22', NULL, 'high', 'With its highly visual content and interactive lift-the-flaps, this book is excellent for introducing and reinforcing basic vocabulary, encouraging naming, and stimulating language development for a child with suspected delays in communication.', '2025-12-01 09:49:43', '2025-12-01 09:49:43'),
(4, 12, NULL, 'Emotion Flashcards for Kids (Real Photos)', 'flashcard', 'educational_toys', 'social_emotional', 'visual', '\"emotion flashcards kids,\" \"feelings cards real pictures,\" \"social emotional learning tools\"', '2-6 years', 30.00, 'mid_range', 'https://www.amazon.com/s?k=%22emotion+flashcards+kids%2C%22+%22feelings+cards+real+pictures%2C%22+%22social+emotional+learning+tools%22', 'https://shopee.com.my/search?keyword=%22emotion+flashcards+kids%2C%22+%22feelings+cards+real+pictures%2C%22+%22social+emotional+learning+tools%22', 'https://www.lazada.com.my/catalog/?q=%22emotion+flashcards+kids%2C%22+%22feelings+cards+real+pictures%2C%22+%22social+emotional+learning+tools%22', NULL, 'medium', 'Utilizes real photographs, aligning with her strong visual learning style, to help Lam Ah Li recognize and name different emotions, facilitating discussions about feelings and promoting social-emotional understanding.', '2025-12-01 09:49:43', '2025-12-01 09:49:43'),
(5, 15, NULL, 'LeapFrog AlphaPup', 'toy', 'educational_toys', 'english', 'auditory', 'LeapFrog AlphaPup alphabet toy letters sounds', '1-3 years', 120.00, 'premium', 'https://www.amazon.com/s?k=LeapFrog+AlphaPup+alphabet+toy+letters+sounds', 'https://shopee.com.my/search?keyword=LeapFrog+AlphaPup+alphabet+toy+letters+sounds', 'https://www.lazada.com.my/catalog/?q=LeapFrog+AlphaPup+alphabet+toy+letters+sounds', NULL, 'high', 'This interactive toy introduces letters and their sounds through music and lights, directly appealing to unreal lam\'s strong auditory and visual learning styles, and emerging interest in letters.', '2025-12-04 12:02:21', '2025-12-04 12:02:21'),
(6, 15, NULL, 'Usborne My First Phonics Reading Library', 'book', 'books', 'english', 'reading_writing', 'Usborne Phonics Reading Library early reader books', '3-5 years', 180.00, 'premium', 'https://www.amazon.com/s?k=Usborne+Phonics+Reading+Library+early+reader+books', 'https://shopee.com.my/search?keyword=Usborne+Phonics+Reading+Library+early+reader+books', 'https://www.lazada.com.my/catalog/?q=Usborne+Phonics+Reading+Library+early+reader+books', NULL, 'high', 'A collection of simple, engaging books designed for early readers, it will support unreal lam\'s active interest in letters and words and provide rich visual content for discussion.', '2025-12-04 12:02:21', '2025-12-04 12:02:21'),
(7, 15, NULL, 'Melissa & Doug Magnetic Wooden Alphabet', 'learning_tool', 'educational_toys', 'english', 'reading_writing', 'Melissa & Doug magnetic alphabet letters fridge magnets', '3-6 years', 70.00, 'premium', 'https://www.amazon.com/s?k=Melissa+%26+Doug+magnetic+alphabet+letters+fridge+magnets', 'https://shopee.com.my/search?keyword=Melissa+%26+Doug+magnetic+alphabet+letters+fridge+magnets', 'https://www.lazada.com.my/catalog/?q=Melissa+%26+Doug+magnetic+alphabet+letters+fridge+magnets', NULL, 'medium', 'These magnetic letters encourage early word building and letter recognition, offering a gentle hands-on activity that aligns with the child\'s interest in words without being overly complex kinesthetically.', '2025-12-04 12:02:21', '2025-12-04 12:02:21'),
(8, 15, NULL, 'BBC CBeebies Official Audio Stories (e.g., \"Hey Duggee,\" \"Bluey\")', '', 'digital_apps', 'social_emotional', 'auditory', 'CBeebies audio stories Hey Duggee Bluey audiobook kids', '2-5 years', 40.00, 'mid_range', 'https://www.amazon.com/s?k=CBeebies+audio+stories+Hey+Duggee+Bluey+audiobook+kids', 'https://shopee.com.my/search?keyword=CBeebies+audio+stories+Hey+Duggee+Bluey+audiobook+kids', 'https://www.lazada.com.my/catalog/?q=CBeebies+audio+stories+Hey+Duggee+Bluey+audiobook+kids', NULL, 'medium', 'These audio-only stories leverage unreal lam\'s strong auditory learning style, fostering imagination and listening comprehension without requiring visual engagement, perfect for quiet time or travel.', '2025-12-04 12:02:22', '2025-12-04 12:02:22');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `type` enum('video','app','book','game','article') NOT NULL,
  `description` text DEFAULT NULL,
  `age_min` int(11) DEFAULT NULL,
  `age_max` int(11) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `title`, `type`, `description`, `age_min`, `age_max`, `url`, `created_at`, `updated_at`) VALUES
(1, 'Sesame Street: Count to 20 Song', 'video', 'Fun Sesame Street song that helps children count from 1 to 20 with characters they recognize.', 4, 6, 'https://www.youtube.com/watch?v=tevF4UYGnu8', '2025-11-29 00:46:10', '2025-11-29 00:46:10'),
(3, 'Shapes Song – Super Simple Songs', 'video', 'A gentle, catchy song teaching preschoolers circle, square, triangle, and rectangle with visuals.', 3, 6, 'https://www.youtube.com/watch?v=pfRuLS-Vnjs', '2025-11-29 00:55:12', '2025-11-29 00:55:12'),
(4, 'Days of the Week Song – Singing Walrus', 'video', 'Fun animated song teaching days of the week using repetition and rhythm for memory retention.', 4, 7, 'https://www.youtube.com/watch?v=3tx0rvuXIRg', '2025-11-29 00:56:08', '2025-11-29 00:56:08'),
(5, 'What is Math? – Khan Academy Kids', 'video', 'Introductory video explaining what math means in everyday life using objects and examples.', 4, 7, 'https://www.youtube.com/watch?v=yJ6HzFyXq9Y', '2025-11-29 00:57:01', '2025-11-29 00:57:01'),
(6, 'Where Do Letters Come From? – TedEd Kids', 'video', 'Short educational animation about alphabets & writing origins, suitable for curious kids.', 5, 8, 'https://www.youtube.com/watch?v=c8y32zAQ3v4', '2025-11-29 00:58:17', '2025-11-29 00:58:17'),
(7, 'Oxford Owl Free eBooks', 'book', 'Free e-book library from Oxford University Press with leveled books for preschool children.', 3, 8, 'https://home.oxfordowl.co.uk/reading/free-ebooks/', '2025-11-29 01:02:34', '2025-12-10 14:53:32'),
(8, 'Storyberries – Free Bedtime Stories', 'book', 'Hundreds of illustrated children’s stories available to read online for free.', 3, 8, 'https://www.storyberries.com/', '2025-11-29 01:04:57', '2025-11-29 01:04:57'),
(9, 'Highlights Kids – Read & Explore', 'book', 'Short stories & literacy resources from the famous Highlights children’s magazine.', 3, 8, 'https://www.highlightskids.com/read', '2025-11-29 01:06:03', '2025-12-10 14:53:25'),
(10, 'Kids World Fun – Moral Stories', 'book', 'Large library of simple moral stories promoting social and emotional learning.', 3, 8, 'https://www.kidsworldfun.com/shortstories.php', '2025-11-29 01:08:55', '2025-12-10 14:53:19'),
(11, 'Fun with Numbers: Counting 1–10', 'video', 'An interactive video that introduces basic number counting from 1 to 10 using songs, animations, and real-life objects to help preschool children understand numbers easily.', 4, NULL, 'https://www.youtube.com/watch?v=DR-cfDsHCGA', '2025-12-10 18:40:07', '2025-12-10 18:40:07');

-- --------------------------------------------------------

--
-- Table structure for table `tests`
--

CREATE TABLE `tests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tests`
--

INSERT INTO `tests` (`id`, `user_id`, `name`) VALUES
(7, 11, 'Visual Learning Questionnaire'),
(8, 11, 'Auditory Learning Questionnaire'),
(9, 11, 'Reading/Writing Learning Questionnaire'),
(10, 11, 'Kinesthetic Learning Questionnaire');

-- --------------------------------------------------------

--
-- Table structure for table `test_answers`
--

CREATE TABLE `test_answers` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `answer` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `test_answers`
--

INSERT INTO `test_answers` (`id`, `child_id`, `test_id`, `question_id`, `answer`, `created_at`) VALUES
(81, 12, 10, 62, '3', '2025-11-30 22:54:50'),
(82, 12, 10, 63, '3', '2025-11-30 22:54:50'),
(83, 12, 10, 64, '3', '2025-11-30 22:54:50'),
(84, 12, 10, 65, '3', '2025-11-30 22:54:50'),
(85, 12, 10, 66, '3', '2025-11-30 22:54:50'),
(86, 12, 9, 52, '4', '2025-11-30 22:54:58'),
(87, 12, 9, 53, '4', '2025-11-30 22:54:58'),
(88, 12, 9, 54, '4', '2025-11-30 22:54:58'),
(89, 12, 9, 55, '4', '2025-11-30 22:54:58'),
(90, 12, 9, 56, '4', '2025-11-30 22:54:58'),
(91, 12, 8, 37, '3', '2025-11-30 22:55:07'),
(92, 12, 8, 38, '4', '2025-11-30 22:55:07'),
(93, 12, 8, 39, '3', '2025-11-30 22:55:07'),
(94, 12, 8, 40, '5', '2025-11-30 22:55:07'),
(95, 12, 8, 41, '4', '2025-11-30 22:55:07'),
(96, 12, 7, 42, '5', '2025-11-30 22:55:14'),
(97, 12, 7, 43, '5', '2025-11-30 22:55:14'),
(98, 12, 7, 44, '5', '2025-11-30 22:55:14'),
(99, 12, 7, 45, '5', '2025-11-30 22:55:14'),
(100, 12, 7, 46, '5', '2025-11-30 22:55:14'),
(101, 15, 10, 62, '1', '2025-12-04 20:00:08'),
(102, 15, 10, 63, '2', '2025-12-04 20:00:08'),
(103, 15, 10, 64, '1', '2025-12-04 20:00:08'),
(104, 15, 10, 65, '2', '2025-12-04 20:00:08'),
(105, 15, 10, 66, '3', '2025-12-04 20:00:08'),
(106, 15, 9, 52, '1', '2025-12-04 20:00:21'),
(107, 15, 9, 53, '5', '2025-12-04 20:00:21'),
(108, 15, 9, 54, '5', '2025-12-04 20:00:21'),
(109, 15, 9, 55, '4', '2025-12-04 20:00:21'),
(110, 15, 9, 56, '2', '2025-12-04 20:00:21'),
(111, 15, 8, 37, '5', '2025-12-04 20:00:30'),
(112, 15, 8, 38, '5', '2025-12-04 20:00:30'),
(113, 15, 8, 39, '5', '2025-12-04 20:00:30'),
(114, 15, 8, 40, '5', '2025-12-04 20:00:30'),
(115, 15, 8, 41, '5', '2025-12-04 20:00:30'),
(116, 15, 7, 42, '4', '2025-12-04 20:00:39'),
(117, 15, 7, 43, '3', '2025-12-04 20:00:39'),
(118, 15, 7, 44, '3', '2025-12-04 20:00:39'),
(119, 15, 7, 45, '4', '2025-12-04 20:00:39'),
(120, 15, 7, 46, '2', '2025-12-04 20:00:39');

-- --------------------------------------------------------

--
-- Table structure for table `test_questions`
--

CREATE TABLE `test_questions` (
  `id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `question` text NOT NULL,
  `answer_type` enum('text','scale') DEFAULT 'text',
  `category` varchar(50) NOT NULL DEFAULT 'general',
  `media_type` varchar(20) DEFAULT NULL,
  `media_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `test_questions`
--

INSERT INTO `test_questions` (`id`, `test_id`, `question`, `answer_type`, `category`, `media_type`, `media_path`) VALUES
(37, 8, 'My child enjoys listening to stories, songs, or rhymes. ( 1 : very disagree  -  5 : very agree)', 'scale', 'auditory', NULL, NULL),
(38, 8, 'My child often repeats words or talks to themselves while learning. ( 1 : very disagree  -  5 : very agree)', 'scale', 'auditory', NULL, NULL),
(39, 8, 'My child remembers instructions better when they are spoken instead of written. ( 1 : very disagree  -  5 : very agree)', 'scale', 'auditory', NULL, NULL),
(40, 8, 'My child likes to ask questions and discuss topics out loud. ( 1 : very disagree  -  5 : very agree)', 'scale', 'auditory', NULL, NULL),
(41, 8, 'My child enjoys sound-based games (songs, rhyming, clapping patterns). ( 1 : very disagree  -  5 : very agree)', 'scale', 'auditory', NULL, NULL),
(42, 7, 'My child likes to look at pictures, books, or charts when learning something new. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(43, 7, 'My child remembers things better when seeing them rather than hearing them. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(44, 7, 'My child is attracted to bright colours, drawings, and visual materials. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(45, 7, 'My child often points to pictures or images when explaining something. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(46, 7, 'If given a choice, my child prefers watching videos instead of only listening. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(52, 9, 'My child likes to look at written words, labels, or simple text. ( 1 : very disagree  -  5 : very agree)', 'scale', 'reading', NULL, NULL),
(53, 9, 'My child enjoys tracing letters or copying simple words. ( 1 : very disagree  -  5 : very agree)', 'scale', 'reading', NULL, NULL),
(54, 9, 'My child points at words or follows with a finger while reading. ( 1 : very disagree  -  5 : very agree)', 'scale', 'reading', NULL, NULL),
(55, 9, 'My child asks what words say when they see text in books or on signs. ( 1 : very disagree  -  5 : very agree)', 'scale', 'reading', NULL, NULL),
(56, 9, 'My child prefers looking at written instructions instead of only listening. ( 1 : very disagree  -  5 : very agree)', 'scale', 'reading', NULL, NULL),
(62, 10, 'My child learns better when there is hands-on activity (drawing, building, playing). ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(63, 10, 'My child often moves around or fidgets when learning. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(64, 10, 'My child remembers things better after doing an activity. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(65, 10, 'My child likes to touch and explore objects when they are curious. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL),
(66, 10, 'My child finds it hard to sit still for a long time during quiet learning. ( 1 : very disagree  -  5 : very agree)', 'scale', 'visual', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('parent','admin') NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `protected_from_deletion` tinyint(1) DEFAULT 0,
  `inactive_warning_sent` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deletion_reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`, `last_login`, `is_active`, `protected_from_deletion`, `inactive_warning_sent`, `deleted_at`, `deletion_reason`) VALUES
(7, 'TongYi Wen', 'tongyw-wm22@student.tarc.edu.my', '$2b$12$2bBrg98cIZ4TMCVwufm2Y.tuIv/Yt9tlrWAz46gudmkeZlDfJMVKG', 'parent', '2025-09-22 15:30:50', NULL, 1, 1, NULL, NULL, NULL),
(9, 'Lam Ah Kao', 'shaucharn@gmail.com', '$2b$12$Pp957FMqRboKXb.3lGkMLOEhaqglyF8qOiAK8dRmajnnx0DDMBko6', 'parent', '2025-11-18 18:15:07', '2025-12-10 14:03:26', 1, 0, NULL, NULL, NULL),
(11, 'admin1', 'admin1@gmail.com', '$2b$12$XB07SM0yICNC8QF/51yPCOMdbV04saOYb2Z7zOQvviw8UXt8CcqLS', 'admin', '2025-11-23 16:04:06', '2025-12-10 14:00:37', 1, 0, NULL, NULL, NULL),
(12, 'ASD', 'adminsc@gmail.com', '$2b$12$JidUcjuu7cmZ5qM7FkpHM.HmpirHYX5TmSjDR9MwJnlm.oo2.lvR.', 'admin', '2025-11-25 07:55:09', NULL, 1, 0, NULL, NULL, NULL),
(13, 'Yi wen', 'tongyiwen2013@gmail.com', '$2b$12$m1TDRB0P3dUs5QolGynt4OuklAda0LCq8vjGUkPnGa.bwGocew18S', 'parent', '2025-10-30 15:21:02', '2025-11-27 17:32:43', 1, 0, NULL, NULL, NULL),
(15, 'yiwenadmin', 'yiwennntong@gmail.com', '$2b$12$KTeWAx2.7O/vmJYOIHJPIecMQNHZkTqKJYgAR5IMUPtm2g176O8ja', 'admin', '2025-11-27 15:27:08', '2025-11-09 18:03:25', 1, 0, NULL, NULL, NULL),
(16, 'Dasabi', 'tongyiwen2003@gmail.com', '$2b$12$B6IxC.UY.0vMIFReNduTROi65I9dAx5GkZz5ZMqHMASktR8mSgbRq', 'parent', '2025-11-27 18:00:39', '2025-11-04 18:00:39', 1, 0, '2025-12-01 13:02:34', NULL, NULL),
(17, 'Lam Ah Sheng', 'fantasticnoob0303@gmail.com', '$2b$12$ameFqfyQa40NFNbeFRCtq.7DwjYpRjlfQqoBNDwbpQIJPAFiriyRe', 'parent', '2025-12-10 10:43:22', '2025-12-10 11:08:09', 1, 0, NULL, NULL, NULL),
(18, 'Ali', 'asd@gmail.com', '$2b$12$JBhEz9vY3v.NiEXwcGcGNe8TMIZgogXJqMsspXk3szm0kRza8W.zi', 'parent', '2025-12-10 10:52:45', '2025-12-10 10:53:00', 1, 0, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_scores`
--
ALTER TABLE `academic_scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `child_id` (`child_id`);

--
-- Indexes for table `ai_results`
--
ALTER TABLE `ai_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `child_id` (`child_id`);

--
-- Indexes for table `children`
--
ALTER TABLE `children`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `game_results`
--
ALTER TABLE `game_results`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `learning_observations`
--
ALTER TABLE `learning_observations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `child_id` (`child_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`),
  ADD KEY `idx_notifications_parent_read` (`parent_id`,`is_read`,`created_at`),
  ADD KEY `idx_notifications_child` (`child_id`),
  ADD KEY `idx_notifications_type` (`type`,`created_at`),
  ADD KEY `notifications_admin_fk` (`created_by_admin_id`);

--
-- Indexes for table `preschool_assessments`
--
ALTER TABLE `preschool_assessments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `child_id` (`child_id`);

--
-- Indexes for table `product_recommendations`
--
ALTER TABLE `product_recommendations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `child_id` (`child_id`),
  ADD KEY `tutoring_result_id` (`tutoring_result_id`),
  ADD KEY `idx_product_type_priority` (`product_type`,`priority`),
  ADD KEY `idx_child_created` (`child_id`,`created_at`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_subject` (`subject`),
  ADD KEY `idx_learning_style` (`learning_style`),
  ADD KEY `idx_price_range` (`price_range`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tests`
--
ALTER TABLE `tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `test_answers`
--
ALTER TABLE `test_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `child_id` (`child_id`),
  ADD KEY `test_id` (`test_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `test_questions`
--
ALTER TABLE `test_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `test_id` (`test_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_scores`
--
ALTER TABLE `academic_scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `ai_results`
--
ALTER TABLE `ai_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `children`
--
ALTER TABLE `children`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `game_results`
--
ALTER TABLE `game_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `learning_observations`
--
ALTER TABLE `learning_observations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `preschool_assessments`
--
ALTER TABLE `preschool_assessments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `product_recommendations`
--
ALTER TABLE `product_recommendations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tests`
--
ALTER TABLE `tests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `test_answers`
--
ALTER TABLE `test_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `test_questions`
--
ALTER TABLE `test_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academic_scores`
--
ALTER TABLE `academic_scores`
  ADD CONSTRAINT `academic_scores_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ai_results`
--
ALTER TABLE `ai_results`
  ADD CONSTRAINT `ai_results_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `children`
--
ALTER TABLE `children`
  ADD CONSTRAINT `children_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `learning_observations`
--
ALTER TABLE `learning_observations`
  ADD CONSTRAINT `learning_observations_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_admin_fk` FOREIGN KEY (`created_by_admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `notifications_child_fk` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `preschool_assessments`
--
ALTER TABLE `preschool_assessments`
  ADD CONSTRAINT `preschool_assessments_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_recommendations`
--
ALTER TABLE `product_recommendations`
  ADD CONSTRAINT `product_recommendations_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_recommendations_ibfk_2` FOREIGN KEY (`tutoring_result_id`) REFERENCES `ai_results` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `tests`
--
ALTER TABLE `tests`
  ADD CONSTRAINT `tests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `test_answers`
--
ALTER TABLE `test_answers`
  ADD CONSTRAINT `test_answers_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `test_answers_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `test_answers_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `test_questions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `test_questions`
--
ALTER TABLE `test_questions`
  ADD CONSTRAINT `test_questions_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
