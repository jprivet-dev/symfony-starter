<?php

namespace App\Form;

use App\Dto\PriceV2Dto;
use App\Form\Type\BcMathNumberType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PriceV2Type extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('priceA', BcMathNumberType::class, ['label' => 'Price A — GreaterThanOrEqual(new BcMath\\Number("0.01"))'])
            ->add('priceB', BcMathNumberType::class, ['label' => 'Price B — GreaterThanOrEqual(new BcMath\\Number("0.01"))'])
            ->add('priceC', BcMathNumberType::class, ['label' => 'Price C — GreaterThanOrEqual(new BcMath\\Number("0.01"))'])
            ->add('priceD', BcMathNumberType::class, ['label' => 'Price D — Range(min: 0, max: 1000)']);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PriceV2Dto::class]);
    }
}
